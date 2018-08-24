//
//  AppDelegate.m
//  SwimClub
//
//  Created by Mick Mossman on 1/12/17.
//  Copyright © 2017 Mick Mossman. All rights reserved.
//
//uploadfimages
//http://www.coderzheaven.com/2014/11/13/nsurlconnection-simple-upload-image-server-post-method/
//[yourString stringByReplacingOccurrencesOfString:@" " withString:@""]
//https://www.codeproject.com/Tips/569532/Submit-Images-to-Web-Service-and-Get-Them-Back
//
#import "AppDelegate.h"
#import "mainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setBarButtonItems];
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    mainViewController *controller = (mainViewController *)navigationController.topViewController;
    
    //controller.managedObjectContext = self.persistentContainer.viewContext;
    //controller.managedObjectContext = self.managedObjectContext;
    /*Use this for my iPad. Hopefully wont need it when i check Chads Ipad*/
    [self addGroups];
    [self addageGroups];
    [self fixDupMembers];
   // NSString *ver = [[UIDevice currentDevice] systemVersion];
    //float ver_float = [ver floatValue];
    //if (ver_float < 10.0) {
        //controller.managedObjectContext = self.managedObjectContext;
   // }else{
        controller.managedObjectContext = self.persistentContainer.viewContext;
    //}
    
    
    return YES;
}


-(void)fixDupMembers {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Events" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"location=%@",@"Test"];
    
    //NSLog(@"eventid=%d",myEvent.eventid);
    
    [fetchRequest setPredicate:pred];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] != 0) {
        for (SwimClubEvents *ev in fetchedObjects) {
            [context deleteObject:ev];
            /*
            mem.webid = 217;
            if (![context save:&error]) {
                CoreDataError *err = [[CoreDataError alloc] init];
                [err showError:error];
            }
            */
            //NSLog(@"Name=%@",ev.eventname);
        }
        
    }
}

-(void)addageGroups {
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"AgeGroups" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"cnt=%lu",fetchedObjects.count);
    if ([fetchedObjects count] == 0) {
        for (int i=1;i<12;i++) {
            switch (i) {
                case 1:
                    [self createAgeGroup:@"Under 10" minage:0 maxage:9 theid:i];
                    break;
                case 2:
                    [self createAgeGroup:@"10 to 11" minage:10 maxage:11 theid:i];
                    break;
                
                case 3:
                    [self createAgeGroup:@"12 to 14" minage:12 maxage:14 theid:i];
                    break;
                case 4:
                    [self createAgeGroup:@"15 to 19" minage:15 maxage:19 theid:i];
                    break;
                case 5:
                    [self createAgeGroup:@"20 to 24" minage:20 maxage:24 theid:i];
                    break;
                case 6:
                    [self createAgeGroup:@"25 to 29" minage:25 maxage:29 theid:i];
                    break;
                case 7:
                    [self createAgeGroup:@"30 to 34" minage:30 maxage:34 theid:i];
                    break;
                case 8:
                    [self createAgeGroup:@"35 to 39" minage:35 maxage:39 theid:i];
                    break;
                case 9:
                    [self createAgeGroup:@"40 to 49" minage:40 maxage:49 theid:i];
                    break;

                case 10:
                    [self createAgeGroup:@"50 to 59" minage:50 maxage:59 theid:i];
                    break;
                case 11 :
                    [self createAgeGroup:@"Over 60" minage:60 maxage:100 theid:i];
                    break;
                default:
                    break;
            }
        }
        
    }
    
}
-(void)createAgeGroup: (NSString*)agegrpname minage:(int)startage maxage:(int)endage theid:(int)myid {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    SwimClubAgeGroups *agegrp = [NSEntityDescription
                           insertNewObjectForEntityForName:@"AgeGroups"
                           inManagedObjectContext:context];
    agegrp.agegroupid = myid;
    agegrp.agegroupname = agegrpname;
    agegrp.minage = startage;
    agegrp.maxage = endage;
    NSError *error;
    if (![context save:&error]) {
        CoreDataError *err = [[CoreDataError alloc] init];
        [err showError:error];
    }
}
-(void)addGroups {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Groups" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"cnt=%lu",fetchedObjects.count);
    if ([fetchedObjects count] == 0) {
        for (int i=0;i<4;i++) {
            switch (i) {
                case 0:
                    [self createGroup:@"No Group" intid:i];
                    break;
                case 1:
                    [self createGroup:@"Beginner" intid:i];
                    break;
                case 2:
                    [self createGroup:@"Exporer" intid:i];
                    break;
                case 3:
                    [self createGroup:@"Performer" intid:i];
                    break;
                //case 4:
                    //[self createGroup:@"Makos" intid:i];
                    //break;
                default:
                    break;
            }
        }
        
    }
    
}
-(void)createGroup: (NSString*)grpname intid:(int)theid {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    SwimClubGroups *grp = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Groups"
                           inManagedObjectContext:context];
    grp.groupid = theid;
    grp.groupname = grpname;
    grp.startseconds=0;
    grp.endseconds=0;
    NSError *error;
    if (![context save:&error]) {
        CoreDataError *err = [[CoreDataError alloc] init];
        [err showError:error];
    }
}


/*old store coordinator for version less than 10*/

 - (NSManagedObjectContext *)managedObjectContext
 {
 if (__managedObjectContext != nil) {
 return __managedObjectContext;
 }
 
 NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
 if (coordinator != nil) {
 __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
 [__managedObjectContext setPersistentStoreCoordinator:coordinator];
 }
 return __managedObjectContext;
 }
 
 // Returns the managed object model for the application.
 // If the model doesn't already exist, it is created from the application's model.
 - (NSManagedObjectModel *)managedObjectModel
 {
 if (__managedObjectModel != nil) {
 return __managedObjectModel;
 }
 NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SwimClub" withExtension:@"momd"];
 __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
 return __managedObjectModel;
 }

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SwimClub.sqlite"];
    
    
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        //[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
        
        /****************************************************
         TO MIGRATE ADATABASE
         1. MAKE A NEW VERSION (ADD MODEL VERSION->EDITOR MENU)
         2. UPDATE THE NEW VERSION
         3. MAKE THE NEW VERSION TO CURRENT VERSION (IN UTILITIES EDITOR)
         4. RUN CODE BELOW
         *****************************************************/
        
        
        if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:
              [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil] error:&error]) {
            //NSLog(@"fucked");
        }else{
            //NSLog(@"Migrated baby");
        }
        
        
        
        
    }
    
    return __persistentStoreCoordinator;
}


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)setBarButtonItems {
    /*Here gives me bar button items that look professional without resorting to png*/
    UIFont *btnFont = [UIFont fontWithName:@"Verdana" size:20.0];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:btnFont
       }
     forState:UIControlStateNormal];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    NSArray *arr = [[NSArray alloc] initWithArray:navigationController.viewControllers];
    NSInteger index = -1;
    for(int i=0 ; i<[arr count] ; i++)
    {
        if([[arr objectAtIndex:i] isKindOfClass:NSClassFromString(@"eventViewController")])
        {
            index = i;
            break;
        }
    }
    if (index != -1) {
        eventViewController *vc = [arr objectAtIndex:index];
        if (vc.timeron) {
            //[pref setTimerRunningOnExit:@"YES"];
            //SEGUE = 'MAINTOEVENT'
            [self saveRunningEvent:vc.currentEvent.eventid runningseconds:vc.noseconds];
            [navigationController popToRootViewControllerAnimated:NO];
            [self addNotification];
        }
        
    }
    
   
    
}

-(void)saveRunningEvent: (int) eventid runningseconds:(int) runsec{
    /*save running data away and set a notification*/
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"SysControl" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"cnt=%lu",fetchedObjects.count);
    if ([fetchedObjects count] != 0) {
        for (SwimClubSysControl *sys in fetchedObjects) {
            sys.runningeventid =eventid;
            sys.runningeventseconds = runsec;
            sys.runningeventstopped = [NSDate date];
            
            NSError *error;
            if (![context save:&error]) {
                CoreDataError *err = [[CoreDataError alloc] init];
                [err showError:error];
            }
        }
    }
    
}
- (void)addNotification {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=1;
    
    //UIApplication.shared.applicationIconBadgeNumber = 1;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];    
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!error) {
                                  NSLog(@"request authorization succeeded!");
                                  //[self showAlert];
                              }
                          }];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //NSLog(@"in did become active");
    
    
    if (self.isActiveEvent) {
        /* go to the timer view controller */
        
        /* we need to check here if the date tht was loast saved wasnt longer thna aday ago
         otherwise the timer is ridiculous and the user has obvously forgotten so I'll reset*/
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeAllDeliveredNotifications];
        
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        
        mainViewController *controller = (mainViewController *)navigationController.topViewController;
        
        controller.managedObjectContext = self.persistentContainer.viewContext;
        
        [controller performSegueWithIdentifier:@"MAINTOEVENT" sender:self];
        
    }
   
    //reset the badge number on app load
    //UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["my.notification"])
}



-(BOOL)isActiveEvent {
    BOOL isActive = NO;
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"SysControl" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] !=0) {
        for (SwimClubSysControl *sys in fetchedObjects) {
            
            if (sys.runningeventid != 0) {
                NSDate *dateStopped = sys.runningeventstopped;
                int findTimediff = [self findEventTimeDiff:dateStopped];
                if (findTimediff > 0 && findTimediff < 36000) {
                    isActive = YES;
                }else{
                    //reset if longer than 10 hours
                    sys.runningeventid = 0;
                    sys.runningeventseconds= 0;
                    sys.runningeventstopped = nil;
                    NSError *error;
                    if (![context save:&error]) {
                        CoreDataError *err = [[CoreDataError alloc] init];
                        [err showError:error];
                    }
                }
            }
            break;
        }
    }else{

       SwimClubSysControl *sys  = [NSEntityDescription
                               insertNewObjectForEntityForName:@"SysControl"
                               inManagedObjectContext:context];
        sys.runningeventid = 0;
        sys.runningeventseconds= 0;
        //sys.runningeventstopped = nil;
        NSError *error;
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            [err showError:error];
        }
    }
    return isActive;
}

-(int)findEventTimeDiff:(NSDate*) evStopped {
    
    /* dtn do ithis if vover 10 hours otherwise rdiculaout*/
    timeFunctions *tf = [[timeFunctions alloc] init];
    
    /* dtn do ithis if vover 10 hours otherwise rdiculaout*/
    return [tf findTimeDiffinSeconds:evStopped];
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack
@synthesize persistentContainer = _persistentContainer;



- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        //NSLog(@"System Version is %@",[[UIDevice currentDevice] systemVersion]);
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"SwimClub"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
        

    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
