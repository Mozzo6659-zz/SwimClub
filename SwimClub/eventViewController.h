//
//  eventViewController.h
//  SwimClub
//
//  Created by Mick Mossman on 5/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "membersViewController.h"
#import "CoreDataError.h"
#import "CoreData/SwimClubEvents+CoreDataClass.h"
#import "CoreData/SwimClubEventResults+CoreDataProperties.h"
#import "CoreData/SwimClubMembers+CoreDataClass.h"
#import "CoreData/SwimClubGroups+CoreDataClass.h"
#import "timeFunctions.h"
#import "resultsViewController.h"
#import "adjustEstimateViewController.h"
//#include "Constants.h"

@interface eventViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    
}
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UITableView *tblResults;
@property (strong, nonatomic) SwimClubEvents *currentEvent;
@property (strong, nonatomic) SwimClubEventResults *currentResult;
@property (strong,nonatomic) NSTimer *timer;
@property (nonatomic,assign) BOOL timeron;
 @property (nonatomic,assign) int noseconds;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;
- (IBAction)ResetEvent:(id)sender;


- (IBAction)startStopTimer:(id)sender;


@end
