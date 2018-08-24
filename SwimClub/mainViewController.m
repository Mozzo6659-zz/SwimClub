//
//  ViewController.m
//  SwimClub
//
//  Created by Mick Mossman on 1/12/17.
//  Copyright © 2017 Mick Mossman. All rights reserved.
//

#import "mainViewController.h"

@interface mainViewController ()


@end

//@import os.log;
//static os_log_t main_log;
@implementation mainViewController


@synthesize btnAddMember;
@synthesize managedObjectContext;
@synthesize btnStartEvent;
@synthesize currentEvent;
@synthesize btnResults;
@synthesize btnUpload;
@synthesize indWait;
@synthesize waitView;
@synthesize lblWait;
@synthesize func1finished = __func1finished;
@synthesize uploadRunnng;
@synthesize timer;

BOOL showfinished = NO;
NSMutableArray *processedEvents;

//BOOL processIsFinished = NO;

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self configureView];
    //[self.navigationController setNavigationBarHidden:true];
    
    //UIApplication.shared.delegate as! appDelegate).persistentContainer.viewContext;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
    
    
}
-(void)viewWillAppear:(BOOL)animated {
     [self.navigationController setNavigationBarHidden:true];
}
-(void) configureView {
    uploadRunnng=NO;
    
    int radd = 30;
    btnDownLoad.layer.cornerRadius = radd;
    btnAddMember.layer.cornerRadius = radd;
    btnStartEvent.layer.cornerRadius = radd;
    btnResults.layer.cornerRadius = radd;
    btnUpload.layer.cornerRadius = radd;
    [_btnResetMmbers setHidden:YES];
    /*wait stuff*/
    CGRect mainrect = self.view.frame;
    CGRect waitframe = CGRectMake(10, 20, mainrect.size.width-20.0, mainrect.size.height/5.0);
    waitView = [[UIView alloc] initWithFrame:waitframe];
    waitView.backgroundColor = [UIColor whiteColor];
    waitView.layer.cornerRadius=10.0;
    
    
    CGRect lblFrame = waitView.frame;
    lblFrame.size.height = lblFrame.size.height /4.0;
    lblWait = [[UILabel alloc] initWithFrame:lblFrame];
    lblWait.textColor = [UIColor blackColor];
    lblWait.text = @"Uploading Members..";
    [lblWait setFont:[UIFont fontWithName:@"Verdana" size:30.0]];
    lblWait.textAlignment = NSTextAlignmentCenter;
    [waitView addSubview:lblWait];
    
    indWait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indWait.color = [UIColor blackColor];
    [waitView addSubview:indWait];
     
    [indWait setCenter:waitView.center];
    //[indWait startAnimating];
   // waitView.frame = CGRectMake(10, 20, mainrect.size.width-20.0, mainrect.size.height/5.0);
    
    
    //lblWait.frame = lblFrame;
    
    //[self.indWait setCenter:waitView.center];
    
    //CENTER THE WAITVIEW LAST OR SUBVIEWS (lblwait and indWait) DONT FOLLOW IT TO CENTER OF THE SCREEN
    //ANOTHER APPLE FEATURE TO WASTE MY DEV TIME ON
    
    [self.view addSubview:waitView];
    
    //[waitView setCenter:self.view.center];
    //[indWait startAnimating];
    [waitView setHidden:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if ([segue.identifier isEqualToString:@"SELECTMEMBERS"]) {
        
        membersListViewController *controller = [segue destinationViewController];
        
        controller.managedObjectContext = self.managedObjectContext;
    }
    if ([segue.identifier isEqualToString:@"SELECTEVENT"]) {
        
        EventsListViewController *controller = [segue destinationViewController];
        
        controller.managedObjectContext = self.managedObjectContext;
        controller.showFinished = showfinished;
        
    }
    
    if ([segue.identifier isEqualToString:@"TESTRESULTS"]) {
        [self loadCurentEvent];
        resultsViewController *controller = [segue destinationViewController];
        controller.myEvent = self.currentEvent;
        
        controller.managedObjectContext = self.managedObjectContext;
    }
    
    if ([segue.identifier isEqualToString:@"MAINTOEVENT"]) {
        NSManagedObjectContext *context = self.managedObjectContext;
        /*get all theevent detatails and pass wot eventViewController*/
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"SysControl" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error;
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        for (SwimClubSysControl *sys in fetchedObjects) {
            NSFetchRequest *evFetch = [[NSFetchRequest alloc] init];
            NSEntityDescription *eventity = [NSEntityDescription
                                           entityForName:@"Events" inManagedObjectContext:context];
            [evFetch setEntity:eventity];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"eventid=%d",sys.runningeventid];
            
            //NSLog(@"eventid=%d",myEvent.eventid);
            
            [evFetch setPredicate:pred];
            NSError *error;
            NSArray *evfetchedObjects = [context executeFetchRequest:evFetch error:&error];
            int startseconds = 0;
            NSDate *eventstopped = [[NSDate alloc] init];
            SwimClubEvents *currentEvent = [[SwimClubEvents alloc] init];
            for (SwimClubEvents *ev in evfetchedObjects) {
                currentEvent = ev;
                startseconds = sys.runningeventseconds;
                eventstopped = sys.runningeventstopped;
                startseconds += [self findEventTimeDiff:eventstopped];
                break;
            }
            //reset sys control
            sys.runningeventid=0;
            sys.runningeventstopped = nil;
            sys.runningeventseconds = 0;
            eventViewController *vc = segue.destinationViewController;
            vc.managedObjectContext = self.managedObjectContext;
            vc.currentEvent = currentEvent;
            vc.noseconds = startseconds;
            
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
-(int)findEventTimeDiff:(NSDate*) evStopped {
    
    timeFunctions *tf = [[timeFunctions alloc] init];
    
    /* dtn do ithis if vover 10 hours otherwise rdiculaout*/
    return [tf findTimeDiffinSeconds:evStopped];
   
}

-(void) loadCurentEvent {
    //DEV FUNCTION
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Events" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count != 0) {
        
        for (SwimClubEvents *ev in fetchedObjects) {
            for (SwimClubEventResults *er in ev.eventResults) {
                if (er.eventid==3) {
                //NSLog(@"eventid=%d evcount=%lu name=%@  memid=%d resulsecs=%d expextedsecs=%d diffsec=%d",er.eventid,[ev.eventResults count], er.member.membername,er.member.memberid,er.resultseconds,er.expectedseconds,er.diffseconds);
                    currentEvent = ev;
                    break;
                }
            }
            
            
        }
        
    }
}

-(void)listEventResults {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    // Edit the entity name as appropriate.
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EventResults" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"eventid=%d",1];
    
    //NSLog(@"eventid=%d",myEvent.eventid);
    
    [fetchRequest setPredicate:pred];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"diffseconds" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    //NSLog(@"cnt=%lu",fetchedObjects.count);
    for (SwimClubEventResults *sr in fetchedObjects) {
        NSLog(@"name=%@ grp=%@",sr.member.membername,sr.member.membergroup.groupname);
    }
    
    
    
}
-(void)listEventDetails {
    /*testing to see wht  got*/
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Events" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        for (SwimClubEvents *ev in fetchedObjects) {
            NSLog(@"eventid=%d dist=%d evfinshed=%d",ev.eventid,ev.distancemtrs,ev.isfinished);
            for (SwimClubEventResults *er in ev.eventResults) {
                //if (er.eventid==2) {
                
                
                NSLog(@"eventid=%d evcount=%lu name=%@  memid=%d resulsecs=%d expextedsecs=%d diffsec=%d",er.eventid,[ev.eventResults count], er.member.membername,er.member.memberid,er.resultseconds,er.expectedseconds,er.diffseconds);
            }
           
            
        }
        
    }
    
}
-(void)listMembers {
    /*testing to see wht  got*/
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Members" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        for (SwimClubMembers *mem in fetchedObjects) {
            NSLog(@"memid=%d webid=%d name=%@  oneksecs=%d",mem.memberid,mem.webid,mem.membername,mem.onekseconds);
           
        }
        
    }
    
}

-(void)deleteAgeGroups {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"AgeGroups" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        for (SwimClubAgeGroups *mem in fetchedObjects) {
            [context deleteObject:mem];
            
        }
        
        NSError *error;
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }
    }
}
-(void)deleteGroups {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Groups" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        for (SwimClubGroups *mem in fetchedObjects) {
            [context deleteObject:mem];
            
        }
        
        NSError *error;
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }
    }
}
-(void)deleteEvents {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Events" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        for (SwimClubEvents *mem in fetchedObjects) {
            [context deleteObject:mem];
            
        }
        
        NSError *error;
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }
    }
}
-(void)deleteEventResults {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"EventResults" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        for (SwimClubEventResults *mem in fetchedObjects) {
            [context deleteObject:mem];
            
        }
        
        NSError *error;
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }
    }
}
-(void)deleteMembers {
    /*testing sub*/
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Members" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        for (SwimClubMembers *mem in fetchedObjects) {
            [context deleteObject:mem];
            
        }
        
        NSError *error;
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }
    }
    
}

-(void)resetMemberWebId {
    /*testing sub*/
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Members" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        for (SwimClubMembers *mem in fetchedObjects) {
            mem.webid =0;
            
        }
        
        NSError *error;
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }
    }
}

-(void)resetEventswebid {
    /*testing sub*/
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Events" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        for (SwimClubEvents *mem in fetchedObjects) {
            mem.webid =0;
            
        }
        
        NSError *error;
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }
    }
}
-(void)addEvent {
    NSManagedObjectContext *context = self.managedObjectContext;
    SwimClubEvents *ev  = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Events"
                             inManagedObjectContext:context];
    ev.eventid=1;
    ev.location = @"testing";
    ev.distancemtrs = 1000;
    ev.isfinished=0;
    NSError *error;
    if (![context save:&error]) {
        
        NSLog(@"Error: %@",[error description]);
       
    }
}
- (IBAction)resetMembers:(id)sender {
    //[self deleteAgeGroups];
    //[self resetMemberWebId];
    //[self resetEventswebid];
    
    //[self listMembers];
    //[self listEventResults];
    //[self deleteGroups];
    [self deleteEvents];
    [self deleteEventResults];
    [self deleteMembers];
    //[self listEventDetails];
    //[self addEvent];
    //[self performSegueWithIdentifier:@"TESTRESULTS" sender:self];
    /*telling the birthday use this as caculated column*/
    /*
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *mydbdaystr = @"1962-08-16";
    NSDate *mybday = [dateFormat dateFromString:mydbdaystr];
    int myage = [self age:mybday];
    NSLog(@"IM AM %d yesrs of age",myage);
     */
}

- (IBAction)goToMembers:(id)sender {
    if (!uploadRunnng) {
        [self performSegueWithIdentifier:@"SELECTMEMBERS" sender:self];
    }
}

- (IBAction)gotoEvents:(id)sender {
    if (!uploadRunnng) {
        if ([sender isEqual:btnStartEvent]) {
            showfinished = NO;
        }else {
            showfinished = YES;
        }
        [self performSegueWithIdentifier:@"SELECTEVENT" sender:self];
    }
}

- (IBAction)goToresults:(id)sender {
}

-(void)getEvents {
    
   
    webFunctions *w = [[webFunctions alloc] init];
    
    //[w getEvents];
    
    NSString *thecommand = @"GetEventsToDownloadJSON";
    NSString *envelopeText = [w getStartEnvelope];
    
    envelopeText = [envelopeText stringByAppendingString:thecommand];
    envelopeText = [envelopeText stringByAppendingString:@" xmlns=\"https://hammerheadsoftware.com.au/\" />\n"];
    envelopeText = [envelopeText stringByAppendingString:[w getEndEnvelope]];
    
    //NSLog(@"%@",envelopeText);
    [w sendRequest:envelopeText thecommand:thecommand completion: ^(NSString *str, NSError *error) {
        
        if (error) {
            //[self showError:[error localizedDescription]];
        } else {
            NSString *cmdResult = [thecommand stringByAppendingString:@"Result"];
            NSString *sJSON = [w filertSOAPJSONstring:str srchstring:cmdResult];
            
            //NSLog(@"%@",sJSON);
            NSData *dJSON = [sJSON dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *err;
            NSDictionary *responseData = [[NSDictionary alloc] init];
            responseData = [NSJSONSerialization JSONObjectWithData:dJSON options:kNilOptions error:&err];
            
            //[self updateEvents:responseData]; //this will run
            
            
            // NSLog(@"err=%@",err.description);
            //NSLog(@"count=%lu",[responseData count]);
            
            //both of these work
            
            for (id item in responseData) {
                NSLog(@"%@ dist=%@",[item valueForKey:@"eventname"],[item valueForKeyPath:@"distancemtrs"]);
            }
            
        }
    }];
    //NSLog(@"this get run before completion block finishes");
    /*
     NSMutableDictionary *res = w.responseData;
     
     NSLog(@"cnt=%lu",[res count]);
     for (id item in res) {
     NSLog(@"%@",[item valueForKey:@"eventid"]);
     }
     for (NSString *item in res) {
     NSLog(@"%@",[item valueForKey:@"eventid"]);
     }
     */
    
}
- (IBAction)uploadData:(id)sender {
    /*testing to see wht  got*/
    /*comment out for chads*/
    //timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(doStop) userInfo:nil repeats:YES];
    if (!uploadRunnng) {
        [self setFunc1finished:NO];
        [self uploadMembers]; //upoad members if it runs will uploadevents as well
        
        if ([self func1finished]) {
            //if here the  there were no members to upload so upload events if any
            [self setFunc1finished:NO];
            [self uploadEvents];
        }
    }
    //[self stopWait];
    //upload events and get the array and uses that to upload event results
    
}

-(void)uploadMembers {
    /*This runs on main thread*/
    [self startWait:@"Uploading Members"];
    webFunctions *w = [[webFunctions alloc] init];
    NSString *thecommand = @"AddmemberListJSON";
    NSString *envelopeText = [w getStartEnvelope];
    envelopeText = [envelopeText stringByAppendingString:thecommand];
    envelopeText = [envelopeText stringByAppendingString:@" xmlns=\"https://hammerheadsoftware.com.au/\">\n"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Members" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"webid=0 or datachanged=1"];
    
    [fetchRequest setPredicate:pred];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        
        envelopeText = [envelopeText stringByAppendingString:@"<Memberlist>\n"];
        
        for (SwimClubMembers *mem in fetchedObjects) {
            envelopeText = [envelopeText stringByAppendingString:@"<clsMembers>\n"];
            envelopeText  = [envelopeText stringByAppendingString:[self addmemberToList:mem]];
            envelopeText = [envelopeText stringByAppendingString:@"</clsMembers>\n"];
            
        }
        envelopeText = [envelopeText stringByAppendingString:@"</Memberlist>\n"];
        envelopeText = [envelopeText stringByAppendingFormat:@"</%@>\n",thecommand];
        envelopeText = [envelopeText stringByAppendingString:[w getEndEnvelope]];
        //NSLog(@"%@",envelopeText);
        [self uploadMemberList:envelopeText command:thecommand];
       
    }else{
        [self setFunc1finished:YES];
        
        //no need for this here.It wil stop the wait view when uploading events if not no events or if there are event resuts
        //[self stopWait];
    }
    
}
-(NSString*)addmemberToList: (SwimClubMembers*)mem {
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    [f2 setDateFormat:@"YYYY-MM-dd"];

    
    NSString *ret = [NSString stringWithFormat:@"<remotememberid>%d</remotememberid>\n",mem.memberid];
    ret = [ret stringByAppendingFormat:@"<remotewebid>%d</remotewebid>\n",mem.webid];
    ret = [ret stringByAppendingFormat:@"<membername>%@</membername>\n",mem.membername];
    ret = [ret stringByAppendingFormat:@"<gender>%@</gender>\n",mem.gender];
    ret = [ret stringByAppendingFormat:@"<swimclubid>%d</swimclubid>\n",mem.swimclubid];
    ret = [ret stringByAppendingFormat:@"<dateofbirth>%@</dateofbirth>\n",[f2 stringFromDate:mem.dateofbirth]];
    ret = [ret stringByAppendingFormat:@"<onekseconds>%d</onekseconds>\n",mem.onekseconds];
     ret = [ret stringByAppendingFormat:@"<emailaddress>%@</emailaddress>\n",mem.emailaddress];
    ret = [ret stringByAppendingFormat:@"<groupid>%d</groupid>\n",mem.swimclubid];
    return ret;
    
}
-(void)uploadMemberList: (NSString*) envelopeText command:(NSString*)thecommand{
    webFunctions *w = [[webFunctions alloc] init];
    [w sendRequest:envelopeText thecommand:thecommand completion: ^(NSString *str, NSError *error) {
        /*It appears this completion block runs on main thread*/
        if (error) {
            //[self showError:[error localizedDescription]];
            const char *msg = [error.description UTF8String];
            os_log(OS_LOG_DEFAULT,"%s", msg);
        } else {
           
            NSString *cmdResult = [thecommand stringByAppendingString:@"Result"];
            //NSLog(@"%@",str);
            NSString *sJSON = [w filertSOAPJSONstring:str srchstring:cmdResult];
            
            //NSLog(@"%@",sJSON);
            NSData *dJSON = [sJSON dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *responseData = [[NSDictionary alloc] init];
            responseData = [NSJSONSerialization JSONObjectWithData:dJSON options:kNilOptions error:&err];
            
            NSManagedObjectContext *context = [self managedObjectContext];
            
            for (id dictItem in responseData) {
                //NSLog(@"webid=%@",[dictItem valueForKey:@"webid"]);
                //NSLog(@"remote=%@",[dictItem valueForKey:@"remotememberid"]);
                NSString *errormsg = [dictItem valueForKey:@"errormessage"];
                
                if (errormsg==nil) {
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                    
                    
                    NSEntityDescription *entity = [NSEntityDescription
                                                   entityForName:@"Members" inManagedObjectContext:context];
                    [fetchRequest setEntity:entity];
                    
                    
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"memberid = %@",[dictItem valueForKey:@"remotememberid"]];
                    [fetchRequest setPredicate:pred];
                    NSError *error;
                    
                    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
                    
                    if (fetchedObjects.count != 0) {
                        for (SwimClubMembers *mem in fetchedObjects) {
                            mem.webid = [[dictItem valueForKey:@"webid"] intValue]; //there wll be only 1;
                            mem.datachanged=0;
                            NSError *error;
                            if (![context save:&error]) {
                                CoreDataError *err = [[CoreDataError alloc] init];
                                [err showError:error];
                            }
                        }
                        
                    }
                }else{
                    //Use the console app in Finder under Applications/Utlities its in the SwimClub process. On this mac its under macbook Pro
                    const char *msg = [errormsg UTF8String];
                    os_log(OS_LOG_DEFAULT,"%s", msg);

                }
                
            }
            
            [self setFunc1finished:YES];
            //[self stopWait];
        }
        if ([self func1finished]) {
            [self uploadEvents];
        }
    }];
    
    
}

-(void)doStop {
    //SEEMS TO ONLY BE AN ISSUE ON THE SIMULATOR-ITS WORKING ON THE IPAD RUN 3 TIMES
    /*Im tried callin this from a timer and it STILL didnt hide*/
    //all settings seem to work except hide
    if (!uploadRunnng) {
    
        [self.indWait stopAnimating];
        //waitView.backgroundColor = [UIColor clearColor]; This setting works
        //doest fuckin work
       // dispatch_async(dispatch_get_main_queue(), ^{
            //display new data on main thread.
            //waitView.hidden=YES;
           
        //});
        
        
        //[self.view sendSubviewToBack:waitView]; this works but it wont hide
        //[waitView setNeedsDisplay]; does fuck all
        //[waitView removeFromSuperview] fuck all also;
        [waitView setHidden:YES];
        [self.view setNeedsDisplay];
        
        //[timer invalidate];
    }
    
}

-(void)stopWait {
    //IM WONDERINF IF ITS JUST IN THE SIMULATOR ? YES IT SEEMS TO BE ON THE SIMULATOR

    
    
    //BUG-this void gets called but my view doesnt disappear.
    //My spinner stops animating even if I dont call stopAnmating.
    
    //ISSUE IS CAUSED BY CALLING THIS VOID FROM A COMPLETION BLOCK (NOT SURE ABOUT THIS NOW)
    //IM CALLING DOSTOP FROM A TIMER AND IT STILL ISNT HIDING
    //this doesnt work either
    //[self performSelectorOnMainThread:@selector(doStop) withObject:nil waitUntilDone:YES];
    //according to NSThread Im on the main thread
    uploadRunnng=NO;
    [self doStop];
    //[self.indWait stopAnimating];
    
    //[waitView setHidden:YES];
    //[self.view setNeedsDisplay];
    
    /*this says its hidden when I can still see the fuckin thing
    if([waitView isHidden]) {
        NSLog(@"Im hidden");
    }else{
         NSLog(@"Im still there to shit you");
    }
     */
    
    //uploadRunnng=NO;
   //[self.indWait stopAnimating];
   // lblWait.text=@"Im stopping";
    //[lblWait setNeedsDisplay];
   //[waitView setHidden:YES];
    //[waitView setNeedsDisplay];
    //[self.view setNeedsDisplay];
    
}

-(void)startWait:(NSString*)lbltext {
    //hides when stopped seems to not hide the damn activity indicator
    
    uploadRunnng=YES;
    lblWait.text=lbltext;
    
    [waitView setHidden:NO];
    [self.indWait startAnimating];
    
}
-(void)uploadEvents {
    /*This runs on main thread*/
    
    [self startWait:@"Uploading Events"];
    webFunctions *w = [[webFunctions alloc] init];
    NSString *thecommand = @"AddeventListJSON";
    NSString *envelopeText = [w getStartEnvelope];
    envelopeText = [envelopeText stringByAppendingString:thecommand];
    envelopeText = [envelopeText stringByAppendingString:@" xmlns=\"https://hammerheadsoftware.com.au/\">\n"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Events" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isfinished=1 and webid=0"];
    
    [fetchRequest setPredicate:pred];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        //Use this later
        
        processedEvents = [[NSMutableArray alloc] init];
        
        envelopeText = [envelopeText stringByAppendingString:@"<eventlist>\n"];
        
        for (SwimClubEvents *ev in fetchedObjects) {
            [processedEvents addObject:[NSNumber numberWithInteger:ev.eventid]];
            envelopeText = [envelopeText stringByAppendingString:@"<clsEvents>\n"];
            envelopeText  = [envelopeText stringByAppendingString:[self addeventToList:ev]];
            envelopeText = [envelopeText stringByAppendingString:@"</clsEvents>\n"];
            
        }
        envelopeText = [envelopeText stringByAppendingString:@"</eventlist>\n"];
        envelopeText = [envelopeText stringByAppendingFormat:@"</%@>\n",thecommand];
        envelopeText = [envelopeText stringByAppendingString:[w getEndEnvelope]];
        //NSLog(@"%@",envelopeText);
        [self uploadeventList:envelopeText command:thecommand];
         
    }else{
        [self setFunc1finished:YES];
        [self stopWait];
    }

}
-(NSString*)addeventToList:(SwimClubEvents*)ev {
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    [f2 setDateFormat:@"YYYY-MM-dd"];
    
    NSString *ret = [NSString stringWithFormat:@"<remoteeventid>%d</remoteeventid>\n",ev.eventid];
    ret = [ret stringByAppendingFormat:@"<remotewebid>%d</remotewebid>\n",ev.webid];
    ret = [ret stringByAppendingFormat:@"<eventname>%@</eventname>\n",@""]; //dont use event name
    ret = [ret stringByAppendingFormat:@"<eventdistance>%d</eventdistance>\n",ev.distancemtrs];
    ret = [ret stringByAppendingFormat:@"<isfinished>%d</isfinished>\n",ev.isfinished];
    ret = [ret stringByAppendingFormat:@"<eventdate>%@</eventdate>\n",[f2 stringFromDate:ev.eventdate]];
    ret = [ret stringByAppendingFormat:@"<eventlocation>%@</eventlocation>\n",ev.location];
        return ret;
}
-(void)uploadeventList:(NSString*) envelopeText command:(NSString*)thecommand {
    webFunctions *w = [[webFunctions alloc] init];
    
    [w sendRequest:envelopeText thecommand:thecommand completion: ^(NSString *str, NSError *error) {
        /*It appears this completion block runs on main thread*/
        //[self startWait:@"Upload eventlits"];
        if (error) {
            //[self showError:[error localizedDescription]];
            const char *msg = [error.description UTF8String];
            os_log(OS_LOG_DEFAULT,"%s", msg);
        } else {
            
            NSString *cmdResult = [thecommand stringByAppendingString:@"Result"];
            //NSLog(@"%@",str);
            NSString *sJSON = [w filertSOAPJSONstring:str srchstring:cmdResult];
            
            //NSLog(@"%@",sJSON);
            NSData *dJSON = [sJSON dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *responseData = [[NSDictionary alloc] init];
            responseData = [NSJSONSerialization JSONObjectWithData:dJSON options:kNilOptions error:&err];
            
            NSManagedObjectContext *context = [self managedObjectContext];
            
            for (id dictItem in responseData) {
                //NSLog(@"webid=%@",[dictItem valueForKey:@"webid"]);
                //NSLog(@"remote=%@",[dictItem valueForKey:@"remotememberid"]);
                NSString *errormsg = [dictItem valueForKey:@"errormessage"];
                
                if (errormsg==nil) {
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                    
                    
                    NSEntityDescription *entity = [NSEntityDescription
                                                   entityForName:@"Events" inManagedObjectContext:context];
                    [fetchRequest setEntity:entity];
                    
                    
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"eventid = %@",[dictItem valueForKey:@"remotememberid"]]; //reusing same return list as addmembers
                    [fetchRequest setPredicate:pred];
                    NSError *error;
                    
                    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
                    
                    if (fetchedObjects.count != 0) {
                        for (SwimClubEvents *ev in fetchedObjects) {
                            ev.webid = [[dictItem valueForKey:@"webid"] intValue]; //there wll be only 1;
                            ev.datachanged=0;//dont use databchanged for events but leave anyways
                            NSError *error;
                            if (![context save:&error]) {
                                CoreDataError *err = [[CoreDataError alloc] init];
                                [err showError:error];
                            }
                        }
                        
                    }
                }else{
                    //Use the console app in Finder under Applications/Utlities its in the SwimClub process. On this mac its under macbook Pro
                    const char *msg = [errormsg UTF8String];
                    os_log(OS_LOG_DEFAULT,"%s", msg);
                    
                }
                
            }
            
            [self setFunc1finished:YES];
        }
        if ([self func1finished]) {
            [self uploadEventResults];
        }
    }];
    
}

-(void)uploadEventResults {
    /*This runs on main thread*/
    webFunctions *w = [[webFunctions alloc] init];
    NSString *thecommand = @"AddeventresultListJSON";
    NSString *envelopeText = [w getStartEnvelope];
    envelopeText = [envelopeText stringByAppendingString:thecommand];
    envelopeText = [envelopeText stringByAppendingString:@" xmlns=\"https://hammerheadsoftware.com.au/\">\n"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"EventResults" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(eventid IN %@)",processedEvents];
    
    [fetchRequest setPredicate:pred];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        //Use this later
       
        
        envelopeText = [envelopeText stringByAppendingString:@"<eventresults>\n"];
        
        for (SwimClubEventResults *ev in fetchedObjects) {
            envelopeText = [envelopeText stringByAppendingString:@"<clsEventResult>\n"];
            envelopeText  = [envelopeText stringByAppendingString:[self addeventresultToList:ev]];
            envelopeText = [envelopeText stringByAppendingString:@"</clsEventResult>\n"];
            
        }
        envelopeText = [envelopeText stringByAppendingString:@"</eventresults>\n"];
        envelopeText = [envelopeText stringByAppendingFormat:@"</%@>\n",thecommand];
        envelopeText = [envelopeText stringByAppendingString:[w getEndEnvelope]];
        //NSLog(@"%@",envelopeText);
        [self uploadeventresultsList:envelopeText command:thecommand];
    }else{
        [self setFunc1finished:YES];
        [self stopWait];
    }
}

-(NSString*)addeventresultToList:(SwimClubEventResults*)ev {
    NSString *ret = [NSString stringWithFormat:@"<eventid>%d</eventid>\n",ev.event.webid];
    ret = [ret stringByAppendingFormat:@"<memberid>%d</memberid>\n",ev.member.webid];
    ret = [ret stringByAppendingFormat:@"<diffseconds>%d</diffseconds>\n",ev.diffseconds];
     ret = [ret stringByAppendingFormat:@"<expectedseconds>%d</expectedseconds>\n",ev.expectedseconds];
     ret = [ret stringByAppendingFormat:@"<resultseconds>%d</resultseconds>\n",ev.resultseconds];
    return ret;
}

-(void)uploadeventresultsList:(NSString*) envelopeText command:(NSString*)thecommand {
    webFunctions *w = [[webFunctions alloc] init];
    
    [w sendRequest:envelopeText thecommand:thecommand completion: ^(NSString *str, NSError *error) {
        /*It appears this completion block runs on main thread*/
        //[self startWait:@"Upload result list"];
        if (error) {
            //[self showError:[error localizedDescription]];
            const char *msg = [error.localizedDescription UTF8String];
            os_log(OS_LOG_DEFAULT,"%s", msg);
        } else {
            
            NSString *cmdResult = [thecommand stringByAppendingString:@"Result"];
            //NSLog(@"%@",str);
            NSString *sJSON = [w filertSOAPJSONstring:str srchstring:cmdResult];
            
            //NSLog(@"%@",sJSON);
            NSData *dJSON = [sJSON dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *responseData = [[NSDictionary alloc] init];
            responseData = [NSJSONSerialization JSONObjectWithData:dJSON options:kNilOptions error:&err];
            
            //NSManagedObjectContext *context = [self managedObjectContext];
            //I do get a list bac here but I dont do anything with it
            for (id dictItem in responseData) {
                //NSLog(@"webid=%@",[dictItem valueForKey:@"webid"]);
                //NSLog(@"remote=%@",[dictItem valueForKey:@"remotememberid"]);
                NSString *errormsg = [dictItem valueForKey:@"errormessage"];
                
                if (errormsg!=nil) {
                    
                    //Use the console app in Finder under Applications/Utlities its in the SwimClub process. On this mac its under macbook Pro
                    const char *msg = [errormsg UTF8String];
                    os_log(OS_LOG_DEFAULT,"%s", msg);
                    
                }
                
            }
            
            [self setFunc1finished:YES];
            
        }
        //this says its on the main thread so I dont know why the fucking view wont disappear when i call stopWait.
        /*
        if([NSThread isMainThread]) {
            NSLog(@"In mainthread");
        }else{
            NSLog(@"Not main thread");
        }
         */
        [self stopWait];
        //I've tried all these and none of em fuckin work. The view wont hide itself unless I click /a button when its over
        
        //[self performSelectorOnMainThread:@selector(stopWait) withObject:nil waitUntilDone:YES];
        //if ([self func1finished]) {
            //dispatch_async(dispatch_get_main_queue(), ^{
                //[waitView setHidden:YES];
                //[self stopWait];
                //NSLog(@"Im on the main thread");
            //});
        //}
    }];
    
}

-(int)age :(NSDate*)birthday {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear
                                               fromDate:birthday
                                                 toDate:[NSDate date]
                                                options:0];
    
    return (int) components.year;
/*this is my property SwimClubMembers+CoreDataClass.h"
 -(int16_t)age {
 NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
 NSDateComponents *components = [calendar components:NSCalendarUnitYear
 fromDate:self.dateofbirth
 toDate:[NSDate date]
 options:0];
 
 return (int) components.year;
 }
 */
 
}

-(BOOL)func1finished {
    return __func1finished;
}

-(void)setFunc1finished:(BOOL)isfinished {
    __func1finished = isfinished;
}
@end
