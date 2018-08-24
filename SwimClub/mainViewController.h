//
//  ViewController.h
//  SwimClub
//
//  Created by Mick Mossman on 1/12/17.
//  Copyright © 2017 Mick Mossman. All rights reserved.
//
#import <os/log.h>
#import <UIKit/UIKit.h>
#import "membersListViewController.h"
#import "EventsListViewController.h"
#import "resultsViewController.h"
#import "CoreData/SwimClubEvents+CoreDataClass.h"
#import "CoreData/SwimClubEventResults+CoreDataClass.h"
#import "CoreData/SwimClubMembers+CoreDataClass.h"
#import "CoreData/SwimClubEventResults+CoreDataClass.h"
#import "CoreData/SwimClubGroups+CoreDataClass.h"
#import "CoreData/SwimClubSysControl+CoreDataClass.h"
#import "webFunctions.h"
#import "timeFunctions.h"
//#include "Constants.h"

@interface mainViewController : UIViewController {
    UIButton *btnDownLoad;
    UIButton *btnAddMember;
    
}

@property (weak, nonatomic) IBOutlet UIButton *btnResetMmbers;



@property(nonatomic,retain) IBOutlet UIButton *btnAddMember;
@property (weak, nonatomic) IBOutlet UIButton *btnStartEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
/*
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indWait;
@property (weak, nonatomic) IBOutlet UILabel *lblWait;
@property (weak, nonatomic) IBOutlet UIView *waitView;
*/
@property (strong, nonatomic)  UIActivityIndicatorView *indWait;
@property (strong, nonatomic)  UILabel *lblWait;
@property (strong, nonatomic)  UIView *waitView;

@property (strong,nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
/*testing event results controller*/
@property (weak, nonatomic) IBOutlet UIButton *btnResults;
@property (strong, nonatomic) SwimClubEvents *currentEvent;
@property (nonatomic, assign) BOOL func1finished;
@property (nonatomic, assign) BOOL uploadRunnng;
- (IBAction)resetMembers:(id)sender;
- (IBAction)goToMembers:(id)sender;
- (IBAction)gotoEvents:(id)sender;
- (IBAction)goToresults:(id)sender;
- (IBAction)uploadData:(id)sender;

@end



