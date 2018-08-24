//
//  membersViewController.m
//  SwimClub
//
//  Created by Mick Mossman on 5/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import "membersViewController.h"

@interface membersViewController ()

@end

@implementation membersViewController
@synthesize managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize selectedEvent;
BOOL quickEntry = NO;
@synthesize mytableview;

//NSMutableArray *selectedMembers;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavItems];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    if (quickEntry) {
        quickEntry=NO;
        
        __fetchedResultsController = nil;
        [mytableview reloadData];
        
        NSRange range = NSMakeRange(0, self.fetchedResultsController.sections.count-1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [mytableview reloadSections:section withRowAnimation:UITableViewRowAnimationFade];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger thecount =[self.fetchedResultsController.sections count];
    return thecount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

-(UIView  *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headerView;
    headerView.backgroundColor = UIColor.clearColor;
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberCell"];
    }else {
        cell.layer.cornerRadius = 8;
    }
    
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    SwimClubMembers *lh = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:40.0];
    cell.textLabel.text = [[lh valueForKey:@"membername"] description];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Verdana" size:20.0];
    
    cell.detailTextLabel.textColor = [UIColor redColor];
    
    
    NSString *dtText = [NSString stringWithFormat:@"Age: %d",lh.age];
    dtText = [dtText stringByAppendingFormat:@"   Group: %@",lh.membergroup.groupname];
    
    cell.detailTextLabel.text = dtText;
    [self updateCellIndicator:cell memberselected:lh.selectedforevent atIndexPath:indexPath];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //SwimClubMembers *ev = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SwimClubMembers *mem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (mem.selectedforevent==0) {
        mem.selectedforevent =1;
       
    }else {
        mem.selectedforevent=0;
        
    }
   
    NSManagedObjectContext *context = self.managedObjectContext;
    NSError *error;
    if (![context save:&error]) {
        CoreDataError *err = [[CoreDataError alloc] init];
        [err showError:error];
    }else {
        [self updateCellIndicator:cell memberselected:mem.selectedforevent atIndexPath:indexPath];
    }
}
-(void)updateCellIndicator: (UITableViewCell*)cell memberselected:(int)isSelected atIndexPath:(NSIndexPath *)indexPath {
    if (isSelected==1) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tickbig7575.png"]];
        
        
        cell.accessoryView = imageView;
        [imageView sizeToFit];
    }else{
        CommonFunctions *mysettings = [[CommonFunctions alloc] init];
        SwimClubMembers *mem = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        //NSLog(@"memid=%d",mem.memberid);
        
        NSString *imgFilePath = [mysettings getFullPhotoPath:[mysettings makePhotoName:mem.memberid]];
        //NSLog(@"%@",imgFilePath);
        
        UIImageView *imgMemberPhoto = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imgFilePath]];
        //[imgMemberPhoto setImage:[UIImage imageWithContentsOfFile:imgFilePath]];
        
        //UIImage *imgMemberPhoto = [UIImage imageWithContentsOfFile:imgFilePath];
        
        CGRect frame = cell.accessoryView.frame;
        
        frame.size.width = 80.0;
        frame.size.height = 90.0;
        imgMemberPhoto.frame = frame;
        imgMemberPhoto.layer.masksToBounds = YES;
        imgMemberPhoto.layer.cornerRadius = 20.0f;
        //[imgMemberPhoto sizeToFit];
        
        cell.accessoryView = imgMemberPhoto;
    }
    
    
}
-(void)getMemberPhoto {
    
    
}
/*
-(void) addMemberToArray:(NSIndexPath *) memid {
 
    if (selectedMembers==nil) {
        selectedMembers = [[NSMutableArray alloc] init];
    }
    [selectedMembers addObject:[self.fetchedResultsController objectAtIndexPath:memid]];
}

-(void) removeMemberFromArray:(NSIndexPath *) memid {
 
    
    if (selectedMembers != nil) {
        
        SwimClubMembers *removemem = [self.fetchedResultsController objectAtIndexPath:memid];

        for (SwimClubMembers *mem in selectedMembers) {
            if ([mem isEqual:removemem]) {
                [selectedMembers removeObject:mem];
                break;
            }
            
        }
    
 
    }
    
}
 */
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"QUICKENTRY"]) {
        quickEntry=YES;
        
        addMemberViewController *controller = [segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
        controller.quickEntry = quickEntry;
    }
}
- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    // Edit the entity name as appropriate.
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Members" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];

    NSMutableArray *memberstoignore = [[NSMutableArray alloc] init];
    
    if (selectedEvent != nil) {
        /*These are the memberids to ignore from this list bcuz they are already registered for the event*/
        for (SwimClubEventResults *evr in selectedEvent.eventResults) {
            [memberstoignore addObject:[NSNumber numberWithInt:evr.memberid]];
            
        }
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"NOT (memberid IN %@)",memberstoignore];
        
        [fetchRequest setPredicate:pred];
    }
    
    
    // Set the batch size to a suitable number.
    //[fetchRequest setFetchBatchSize:150];
    
    // Edit the sort key as appropriate.
    
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"group" ascending:YES];
    
    //REMOVING THIS FOR NOWE
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"membername" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    //END REMOVE THIS FOR NOW
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"membername" cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    __fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![__fetchedResultsController performFetch:&error]) {
        CoreDataError *err = [[CoreDataError alloc] init];
        [err showError:error];
    }
    
    return __fetchedResultsController;
}

-(void) loadNavItems {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Verdana" size:30];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textColor = [UIColor whiteColor];
    label.text = @"Event";
    self.navigationItem.titleView = label;
    
    /*Hide otherwise you get 2 back buttns*/
    [self.navigationItem setHidesBackButton:true animated:NO];
    
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"<< Done"
                                 style:UIBarButtonItemStyleDone
                                 target:self
                                 action:@selector(goback)];
    
    
    UIBarButtonItem *nextitem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Quick Entry >>"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(selMember)];
    
    
    
    [self.navigationItem setLeftBarButtonItem:backitem animated:YES];
    
    [self.navigationItem setRightBarButtonItem:nextitem animated:YES];
    
    
   
}
-(void)selMember {
    /*Call the members erty window wihtminimal details*/
    
    [self performSegueWithIdentifier:@"QUICKENTRY" sender:self];
}
-(void)goback {
    /*Save all memberid's in selectedMebers as new eventresults of the event*/
    [self insertMembersToEvent];
    [self resetVars];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)resetVars {
    __fetchedResultsController = nil;
    selectedEvent = nil;
}
-(void)insertMembersToEvent {
    int anyselected =0;
    NSManagedObjectContext *context = self.managedObjectContext;
    
    timeFunctions *f = [[timeFunctions alloc] init];
    for (SwimClubMembers *mem in self.fetchedResultsController.fetchedObjects) {
        
        if (mem.selectedforevent==1) {
            SwimClubEventResults *ev  = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"EventResults"
                                         inManagedObjectContext:context];
            
            ev.memberid = mem.memberid;
            ev.eventid = selectedEvent.eventid;
            ev.resultseconds = 0;
            ev.expectedseconds = [f adjustOnekSecondsForDistance:selectedEvent.distancemtrs onekseconds:mem.onekseconds];
            //NSLog(@"expected=%d distance=%d memoneksecs:%d",ev.expectedseconds,selectedEvent.distancemtrs,mem.onekseconds);
            ev.diffseconds = 0;
            mem.selectedforevent=0;
            ev.member = mem;
            //NSLog(@"evmemid=%d memmemid=%d eventid=%d membername=%@",ev.memberid,ev.member.memberid,ev.eventid, mem.membername);
            [selectedEvent addEventResultsObject:ev];
            anyselected += 1;
        }
    }
   
    if (anyselected != 0) {
        NSError *error;
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }
    }
   
}
@end
