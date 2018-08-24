//
//  eventViewController.m
//  SwimClub
//
//  Created by Mick Mossman on 5/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import "eventViewController.h"

@interface eventViewController ()

@end

//int minutes = 0;
//int hours = 0;


@implementation eventViewController
@synthesize managedObjectContext;
@synthesize currentEvent;
@synthesize tblResults;
@synthesize timer;
@synthesize btnStart;
@synthesize lblTimer;
@synthesize txtDistance;
@synthesize txtLocation;
@synthesize btnReset;
@synthesize currentResult;
@synthesize timeron;
@synthesize noseconds;

NSMutableArray *selectedEventResults;
BOOL adjustTime = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self loadNavItems];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self maketablecontents:YES];
    [tblResults reloadData];
    
    if (adjustTime) {
        adjustTime = NO; //Dont think i need ths flag but I'll leave it
        currentResult=nil;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)isNewEvent {
    return noseconds==1;
}
-(void)configureView {
    if (currentEvent ==nil) {
        [txtDistance becomeFirstResponder];
    }else{
        //NSString *txt = [NSString stringWithFormat: @"%d", currentEvent.distancemtrs];
        
        txtDistance.text = [NSString stringWithFormat: @"%d", currentEvent.distancemtrs];
        txtLocation.text = currentEvent.location;
        
    }
    [self.navigationController setNavigationBarHidden:false];
    int radd = 30;
    btnStart.layer.cornerRadius = radd;
    btnReset.layer.cornerRadius = radd;
    if (!self.isNewEvent) {
        [self doEventStart];
        timeron = YES;
        [self updateTimer];
    }
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"EVENTMEMBERS"]) {
        NSMutableArray *eventmembers;
        
        for (SwimClubEventResults *sr in currentEvent.eventResults) {
            [eventmembers addObject:[NSNumber numberWithInteger:sr.memberid]];
        }
        membersViewController *controller = [segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
        controller.selectedEvent = currentEvent;
        
    }
    if ([segue.identifier isEqualToString:@"SEERESULTS"]) {
        
        resultsViewController *controller = [segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
        controller.myEvent = self.currentEvent;
        
    }
    if ([segue.identifier isEqualToString:@"ADJUSTESTIMATE"]) {
        adjustEstimateViewController *controller = [segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
        controller.selectedEventResults = currentResult;
    }
    
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
                                 initWithTitle:@"<< Home"
                                 style:UIBarButtonItemStyleDone
                                 target:self
                                 action:@selector(goback)];
    
    
    UIBarButtonItem *nextitem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"+Members >>"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(selMember)];
    
   
    
    [self.navigationItem setLeftBarButtonItem:backitem animated:YES];
    
    [self.navigationItem setRightBarButtonItem:nextitem animated:YES];
    
    
    
}-(void)goback {
    /*HERE YOU NEED TO GET THE LITS OF SELECTED MEMBERS AND RETURN NSMutablearray*/
    if (!timeron) {
        [self removeKeyBoard];
        [self resetVars];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self showError:@"Event is in progress"];
    }
}

-(void)resetVars {
    currentResult = nil;
    currentEvent = nil;
    noseconds=0;
    //minutes=0;
    //hours=0;
    
}
-(void)selMember {
    //perform the segue to go to the members selecting tableview
    if (!timeron) {
        if (self.validateEventDetails) {
            [self createEvent:NO];
            [self removeKeyBoard];
            [self performSegueWithIdentifier:@"EVENTMEMBERS" sender:self];
        }
    }else{
        [self showError:@"Event is in progress"];
    }
}
-(void) removeKeyBoard {
    [txtLocation resignFirstResponder];
    [txtDistance resignFirstResponder];
    
    
}

-(bool) validateEventDetails {
    
    NSString *errmsg;
    
    NSString *myString = txtDistance.text;
    

    
    NSString *loc = txtLocation.text;
    
    if ([myString intValue]==0) {
        errmsg = @"Distance is invalid";
        
    }
    
    if ([loc length]==0) {
         errmsg = @"location is required";
    }
    
    if (errmsg != nil) {
        [self showError:errmsg];
    }
    
    return (errmsg==nil);
}

-(void)showError:(NSString*)msg {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:^{}];
}
-(void)createEvent:(BOOL)withReset {
    NSManagedObjectContext *context = self.managedObjectContext;
    NSError *error;
    
    if(currentEvent==nil) {
        
         NSInteger nextid = [self getNextId];
        SwimClubEvents *ev  = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Events"
                                 inManagedObjectContext:context];
        ev.eventid = (int) nextid;
        ev.location = txtLocation.text;
        ev.distancemtrs =  [txtDistance.text intValue];
        ev.webid = 0; //This is to be reset wiht the id from the TAW database
        ev.eventdate = [NSDate date];
        ev.isfinished=0;
        ev.datachanged = 0;
        
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }else {
            currentEvent = ev;
        }
    }else{
        /*incase they chnage distcnce*/
        //You might a recalc here for members time if distance chnages*/
        currentEvent.distancemtrs = [txtDistance.text intValue];
        currentEvent.location = txtLocation.text;
        currentEvent.datachanged = 1;
        
        if (withReset) {
            timeFunctions *f = [[timeFunctions alloc] init];
            for (SwimClubEventResults *sr in currentEvent.eventResults) {
                sr.resultseconds = 0;
                sr.expectedseconds = [f adjustOnekSecondsForDistance:currentEvent.distancemtrs onekseconds:sr.member.onekseconds];
                
            }
        }
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }
    }
    
    
}

-(NSInteger)getNextId {
    NSInteger nextid = 1;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Events" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    fetchRequest.fetchLimit = 1;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"eventid" ascending:NO]];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        for (SwimClubEvents *mem in fetchedObjects) {
            nextid = mem.eventid;
            nextid += 1;
            
        }
    }
    
    return nextid;
    
}

#pragma mark - Tableview stuff-

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (timeron) {
        [self updateMemberwithResult:indexPath];
    }else{
        currentResult =[selectedEventResults objectAtIndex:indexPath.row+indexPath.section];
        adjustTime=YES;
        [self performSegueWithIdentifier:@"ADJUSTESTIMATE" sender:self];
    }
    
}

-(void)updateMemberwithResult:(NSIndexPath *)indexPath {
    NSString *timetxt = lblTimer.text; //get this first
    
    SwimClubEventResults *selev = [selectedEventResults objectAtIndex:indexPath.row+indexPath.section];
    
    //NSLog(@"memid=%d name=%@ nofoer=%lu",selev.member.memberid,selev.member.membername,[currentEvent.eventResults count]);
    
    timeFunctions *f = [[timeFunctions alloc] init];
    
    
    for (SwimClubEventResults *ev in currentEvent.eventResults) {
        if ([ev isEqual:selev]) {
            //NSArray *thetime = [lblTimer.text componentsSeparatedByString: @":"];
            ev.resultseconds = [f convertTimeToSeconds:timetxt];
            ev.diffseconds = ev.resultseconds - ev.expectedseconds;
            ev.member.agegroup = [self getAgeGroup:ev.member.age];
            //NSLog(@"memid=%d name=%@",ev.member.memberid,ev.member.membername);
            break;
        }
        
    }
    
    NSManagedObjectContext *context = self.managedObjectContext;
    NSError *error = nil;
    if (![context save:&error]) {
        CoreDataError *err = [[CoreDataError alloc] init];
        [err showError:error];
        
        
    }else {
        [self maketablecontents:true];
        [tblResults reloadData];
        
        
        if ([currentEvent.eventResults count] != 0 && [selectedEventResults count]==0) {
            
            [self startStopTimer:self];
            //[self performSegueWithIdentifier:@"SEERESULTS" sender:self];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(UIView  *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headerView;
    headerView.backgroundColor = UIColor.clearColor;
    return headerView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger thecount = [selectedEventResults count];
    
    if (thecount == 0) {
        tblResults.hidden = YES;
        //self.hdrlabel.text = @"Tap New List to start your lists";
    }else {
        tblResults.hidden = NO;
    }
    
    return thecount;
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return !timeron;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    //NSLog(@"Deleted row.");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *context = self.managedObjectContext;
        
        SwimClubEventResults *selev = [selectedEventResults objectAtIndex:indexPath.row + indexPath.section];
        
        for (SwimClubEventResults *ev in currentEvent.eventResults) {
            if ([ev isEqual:selev]) {
                //managedObjectContext.deletedObjects[ev];
                NSMutableSet *mutableSet = [currentEvent.eventResults mutableCopy];
                [mutableSet removeObject:ev];
                currentEvent.eventResults = [mutableSet copy];
                [self maketablecontents:YES];
                //[tblResults reloadData];
                //[tblResults refreshControl];
                break;
            }
        }
        NSError *error = nil;
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
            
            
        }else {
            
            [tblResults reloadData];
        }
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MemberCell"];
    }else {
        cell.layer.cornerRadius = 8;
    }
    
    //UITableViewCellStyleDefault
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    SwimClubEventResults *lh = [selectedEventResults objectAtIndex:indexPath.row + indexPath.section];
    //NSLog(@"name=%@ at Row %lu",lh.member.membername,indexPath.row);
    
    timeFunctions *f = [[timeFunctions alloc] init];
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:35.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Verdana" size:20.0];
    
    //NSLog(@"memberid=%d name=%@",lh.member.memberid,lh.member.membername);
    NSString *textlabel = lh.member.membername;
    
    NSString *dtlLabel = @"Est Time: ";
    
    //int oneksec = lh.member.onekseconds;
    
    /*
    int adjustedSec=[f adjustOnekSecondsForDistance:[txtDistance.text intValue] onekseconds:lh.member.onekseconds];
     */
    //NSLog(@"expected=%d",lh.expectedseconds);
    NSString *timelabel = [f convertSecondsToTime:lh.expectedseconds];
    
    dtlLabel = [dtlLabel stringByAppendingString:timelabel];
    NSString *dtText = [NSString stringWithFormat:@" Age: %d",lh.member.age];
    dtText = [dtText stringByAppendingFormat:@"  Group: %@",lh.member.membergroup.groupname];
    dtlLabel = [dtlLabel stringByAppendingString:dtText];
   
    cell.textLabel.text = textlabel;
    cell.detailTextLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.text = dtlLabel;/*
    if (!timeron) {
        //if timers is nt running show the edit chevron 
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightarrow2-7575.png"]];
        
        [imageView sizeToFit];
        cell.accessoryView = imageView;
    }else {
    */
        CommonFunctions *mysettings = [[CommonFunctions alloc] init];
        
        
        NSString *imgFilePath = [mysettings getFullPhotoPath:[mysettings makePhotoName:lh.member.memberid]];
        UIImageView *imgMemberPhoto = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imgFilePath]];
        
        
        CGRect frame = cell.accessoryView.frame;

        frame.size.width = 80.0;
        frame.size.height = 90.0;
        imgMemberPhoto.frame = frame;
        imgMemberPhoto.layer.masksToBounds = YES;
        imgMemberPhoto.layer.cornerRadius = 20.0f;
        cell.accessoryView = imgMemberPhoto;
        //cell.accessoryView=nil;
    
    //NSLog(@"%@",dtlLabel);
}

-(void) maketablecontents:(BOOL) reset {
    /* The table contets should only be memebrs wiht no results*/
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    // Edit the entity name as appropriate.
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Events" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"eventid=%lu",currentEvent.eventid];
                        
        
    [fetchRequest setPredicate:pred];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (SwimClubEvents *ev in fetchedObjects) {
        currentEvent = ev;
        break;
    }
    
    //NSArray *sortedArray = [selectedEventResults sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    if (selectedEventResults==nil || reset) {
        selectedEventResults = [[NSMutableArray alloc] init];
    }
    for (SwimClubEventResults *ev in currentEvent.eventResults) {
        if (ev.resultseconds==0) {
            //NSLog(@"memid=%d name=%@",ev.member.memberid,ev.member.membername);
            [selectedEventResults addObject:ev];
        }
    }
    
    if ([selectedEventResults count] !=0) {
        NSSortDescriptor *sortDescriptor  = [[NSSortDescriptor alloc] initWithKey:@"expectedseconds" ascending:YES];
                                              
        NSArray *sdesc = [[NSArray alloc] initWithObjects:sortDescriptor,nil];
        [selectedEventResults sortUsingDescriptors:sdesc];
        
    }
    
    
  
}
- (IBAction)ResetEvent:(id)sender {
    timeron = NO;
    [timer invalidate];
    timer = nil;
    [self createEvent:YES];
    [self maketablecontents:YES];
    lblTimer.text = @"00:00:00";
    noseconds=1;
    [btnStart setTitle:@"Start" forState:UIControlStateNormal];
    [tblResults reloadData];
}
-(void)doEventStart {
    [btnStart setTitle:@"Finish" forState:UIControlStateNormal];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    [self maketablecontents:YES];
}
- (IBAction)startStopTimer:(id)sender {
    BOOL bContinue = YES;
    if (!timeron) {
        /*we are startng so check we have people in the race*/
        if ([selectedEventResults count]==0) {
            
            bContinue = NO;
        }
    }
    if (bContinue) {
        if (timeron) {
            [timer invalidate];
            timer = nil;
            
            [self displayResults];
            
        }else {
       
           
            [self doEventStart];
        }
        
        timeron = !timeron;
        [tblResults reloadData];
    }
    
    
}

-(void)displayResults {
    bool goToResults=NO;
    NSManagedObjectContext *context = self.managedObjectContext;
    NSError *error;
    
    currentEvent.isfinished = 1;
    
    if (![context save:&error]) {
        CoreDataError *err = [[CoreDataError alloc] init];
        [err showError:error];
    }
    
    /*finihs the event*/
    for (SwimClubEventResults *er in currentEvent.eventResults) {
        if (er.resultseconds != 0) {
            goToResults = YES;
            break;
        }
    }
    if (goToResults) {
        [self performSegueWithIdentifier:@"SEERESULTS" sender:self];
    }
}
-(void)updateTimer {
    noseconds += 1;
    
    timeFunctions *t = [[timeFunctions alloc] init];
    
    
    [lblTimer setText:[t convertSecondsToTime:noseconds]];
}
/*
-(NSString*) appendToTimerLabel: (int)timeval {
    NSString *retval = [[NSString alloc] init];
    if (timeval < 10) {
        retval = [retval stringByAppendingFormat:@"0%d",timeval];
    }else {
        retval = [retval stringByAppendingFormat:@"%d",timeval];
    }
    
    return retval;
    
}
*/
@end
