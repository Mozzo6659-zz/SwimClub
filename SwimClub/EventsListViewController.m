//
//  EventsListViewController.m
//  SwimClub
//
//  Created by Mick Mossman on 14/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import "EventsListViewController.h"

@interface EventsListViewController ()

@end

@implementation EventsListViewController
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext;
@synthesize selectedEvent;
@synthesize mytableview;
@synthesize showFinished;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:false];
    [self loadNavItems];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) loadNavItems {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Verdana" size:30];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textColor = [UIColor whiteColor];
    label.text = @"Select Event";
    self.navigationItem.titleView = label;
    
    /*Hide otherwise you get 2 back buttns*/
    [self.navigationItem setHidesBackButton:true animated:NO];
    
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"<< Back"
                                 style:UIBarButtonItemStyleDone
                                 target:self
                                 action:@selector(goback)];
    
    if(!showFinished) {
        UIBarButtonItem *nextitem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"+Event >>"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(AddEvent)];
        [self.navigationItem setRightBarButtonItem:nextitem animated:YES];
    
    }
    
    [self.navigationItem setLeftBarButtonItem:backitem animated:YES];
    
    
    
    
    
}

-(void)AddEvent {
    /*Go to the members view controller with no selected Member*/
    [self resetVars];
    [self performSegueWithIdentifier:@"STARTEVENT" sender:self];
}
-(void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)resetVars {
    __fetchedResultsController = nil;
  selectedEvent = nil;
    showFinished = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger thecount =[self.fetchedResultsController.sections count];
    
    
    if (thecount == 0) {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mytableview.bounds.size.width, mytableview.bounds.size.height)];
        noDataLabel.text             = @"No Events to List";
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

-(UIView  *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headerView;
    headerView.backgroundColor = UIColor.clearColor;
    return headerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    selectedEvent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //NSLog(@"name=%@ oneksecs=%d",selectedMember.membername,selectedMember.onekseconds);
    
    //this means all members in the event have a results
    if (showFinished) {
        [self performSegueWithIdentifier:@"SEEFINISHEDRESULTS" sender:self];
    }else{
        [self performSegueWithIdentifier:@"STARTEVENT" sender:self];
    }
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    //CAN delete rows if not in showing finished events
    return !showFinished;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
        SwimClubEvents *selev = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self deleteEvent:selev];
        //NSLog(@"memid=%d",selev.memberid);
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
}

-(void) deleteEvent:(SwimClubEvents*) selev {
    NSManagedObjectContext *context = self.managedObjectContext;
    
    for (SwimClubEventResults *sr in selev.eventResults) {
        [context deleteObject:sr];
    }
    
    [context deleteObject:selev];
    NSError *error = nil;
    if (![context save:&error])
    {
        CoreDataError *err = [[CoreDataError alloc] init];
        [err showError:error];
    }
    __fetchedResultsController = nil;
    [mytableview reloadData];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EVENTCELL" forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 8;
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    
    SwimClubEvents *lh = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *header = lh.location;
    header = [header stringByAppendingFormat:@" (%d)",lh.distancemtrs];
    header = [header stringByAppendingString:@" mtrs)"];
    
    
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:40.0];
    cell.textLabel.text = header;
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Verdana" size:20.0];
    
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    [f2 setDateFormat:@"dd-MM-YYYY"];
    NSString *dtText = [f2 stringFromDate:lh.eventdate];
    
    
    cell.detailTextLabel.text = dtText;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightarrow2-7575.png"]];
    
    [imageView sizeToFit];
    cell.accessoryView = imageView;
    
    //UIImageView imgMemberPhoto
    //cell.accessoryView.frame = CGRectMake(cell.accessoryView.layer., y, width, height);
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"STARTEVENT"]) {
        //this vc can be called from app delegate and timeor on noseconds will be set there so reset themif called from here
        eventViewController *controller = [segue destinationViewController];
        controller.noseconds = 1;
        controller.timeron = NO;
        controller.managedObjectContext = self.managedObjectContext;
        controller.currentEvent = selectedEvent;
    }
    if ([segue.identifier isEqualToString:@"SEEFINISHEDRESULTS"]) {
        [self loadAgeGroups]; //do this here as it doesnt seem to stick first time if doing it n the result view controller
        resultsViewController *controller = [segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
        controller.myEvent = selectedEvent;
    }
}

-(void)loadAgeGroups {
    NSManagedObjectContext *context = self.managedObjectContext;
    
    for (SwimClubEventResults *er in selectedEvent.eventResults) {
        SwimClubMembers *mem = er.member;
        //SwimClubAgeGroups *ag = [self getAgeGroup:mem.age];
        mem.agegroup = [self getAgeGroup:mem.age];
        //NSLog(@"agegp=%@ age=%d name=%@ agid=%d",mem.agegroup.agegroupname,mem.age,mem.membername,mem.agegroup.agegroupid);
        //er.member = mem;
        NSError *error;
        
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }
    }
    
}

-(SwimClubAgeGroups*) getAgeGroup:(int) memberage {
    SwimClubAgeGroups *agegrp;
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AgeGroups" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"minage <= %d and maxage >= %d",memberage,memberage];
    
    [fetchRequest setPredicate:pred];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        for (SwimClubAgeGroups *ag in fetchedObjects) {
            agegrp = ag;
            break;
        }
    }
    return agegrp;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    // Edit the entity name as appropriate.
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Events" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"eventdate" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    int fin = 0;
    if (showFinished) {
        fin = 1;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isfinished=%d",fin];
    
    [fetchRequest setPredicate:pred];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"eventid" cacheName:nil];
    
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
