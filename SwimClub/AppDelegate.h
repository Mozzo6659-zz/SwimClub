//
//  AppDelegate.h
//  SwimClub
//
//  Created by Mick Mossman on 1/12/17.
//  Copyright © 2017 Mick Mossman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreData/SwimClubGroups+CoreDataClass.h"
#import "CoreData/SwimClubAgeGroups+CoreDataClass.h"
#import "eventViewController.h"
#import "CoreData/SwimClubSysControl+CoreDataClass.h"
#import "timeFunctions.h"
@import UserNotifications;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
 

- (void)saveContext;


@end

