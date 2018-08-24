//
//  membersListViewControllerTableViewController.m
//  SwimClub
//
//  Created by Mick Mossman on 14/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import "membersListViewController.h"

@interface membersListViewController ()

@end


@implementation membersListViewController
BOOL backfromMember = NO;
@synthesize managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize mytableview;
@synthesize selectedMember;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:false];
    [self loadNavItems];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    if (backfromMember) {
        //not sure f I need this
        __fetchedResultsController = nil;
        [mytableview reloadData];
        backfromMember = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(void) loadNavItems {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Verdana" size:30];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textColor = [UIColor whiteColor];
    label.text = @"Select Members";
    self.navigationItem.titleView = label;
    
    /*Hide otherwise you get 2 back buttns*/
    [self.navigationItem setHidesBackButton:true animated:NO];
    
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"<< Back"
                                 style:UIBarButtonItemStyleDone
                                 target:self
                                 action:@selector(goback)];
    
    
    UIBarButtonItem *nextitem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"+Member >>"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(AddMember)];
    
    
    
    [self.navigationItem setLeftBarButtonItem:backitem animated:YES];
    
    [self.navigationItem setRightBarButtonItem:nextitem animated:YES];
    
    
    
}

-(void)AddMember {
    /*Go to the members view controller with no selected Member*/
    selectedMember=nil;
    [self performSegueWithIdentifier:@"EDITMEMBERS" sender:self];
}
-(void)goback {
    [self resetVars];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)resetVars {
    __fetchedResultsController = nil;
    selectedMember = nil;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    NSInteger thecount =[self.fetchedResultsController.sections count];
    
    if (thecount == 0) {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mytableview.bounds.size.width, mytableview.bounds.size.height)];
        noDataLabel.text             = @"No Members to List";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.backgroundColor = [UIColor grayColor];
        noDataLabel.layer.cornerRadius = 30;
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        [noDataLabel setFont:[UIFont fontWithName:@"Verdana" size:40]];
        mytableview.backgroundView = noDataLabel;
        mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        mytableview.backgroundView=nil;
    }
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MEMCELL" forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 8;
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    
    SwimClubMembers *lh = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:40.0];
    cell.textLabel.text = lh.membername;
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Verdana" size:20.0];
   
    cell.detailTextLabel.textColor = [UIColor redColor];
    
    timeFunctions *f = [[timeFunctions alloc] init];
    
    NSString *dtText = [NSString stringWithFormat:@"Age: %d",lh.age];
    dtText = [dtText stringByAppendingFormat:@"   Group: %@",lh.membergroup.groupname];
    dtText = [dtText stringByAppendingFormat:@"   One K: %@",[f convertSecondsToTime:  lh.onekseconds]];
    
    cell.detailTextLabel.text = dtText;
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightarrow2-7575.png"]];
    
    //[imageView sizeToFit];
    //cell.accessoryView = imageView;
    
    CommonFunctions *mysettings = [[CommonFunctions alloc] init];
    
 
    NSString *imgFilePath = [mysettings getFullPhotoPath:[mysettings makePhotoName:lh.memberid]];
    
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

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    selectedMember = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //NSLog(@"name=%@ oneksecs=%d",selectedMember.membername,selectedMember.onekseconds);
    
    //this means all members in the event have a results
    [self performSegueWithIdentifier:@"EDITMEMBERS" sender:self];
   
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSManagedObjectContext *context = self.managedObjectContext;
        
        SwimClubMembers *selev = [self.fetchedResultsController objectAtIndexPath:indexPath];
        //NSLog(@"memid=%d",selev.memberid);
        [context deleteObject:selev];
        NSError *error = nil;
        if (![context save:&error])
        {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }
        __fetchedResultsController = nil;
        [mytableview reloadData];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue to members view controller"EDITMEMBERS"
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"EDITMEMBERS"]) {
        backfromMember=YES;
        
        addMemberViewController *controller = [segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
        controller.selectedMember = selectedMember;
        //NSLog(@"name=%@ oneksecs=%d",controller.selectedMember.membername,controller.selectedMember.onekseconds);
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
    
    // Set the batch size to a suitable number.
    //[fetchRequest setFetchBatchSize:150];
    
    // Edit the sort key as appropriate.
    
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"group" ascending:YES];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"membername" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"memberid" cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    __fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![__fetchedResultsController performFetch:&error]) {
        CoreDataError *err = [[CoreDataError alloc] init];
        [err showError:error];
    }
    
    return __fetchedResultsController;
}

@end
