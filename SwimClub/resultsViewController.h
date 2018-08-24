//
//  resultsViewController.h
//  SwimClub
//
//  Created by Mick Mossman on 12/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataError.h"
#import "CoreData/SwimClubMembers+CoreDataClass.h"
#import "CoreData/SwimClubEvents+CoreDataClass.h"
#import "CoreData/SwimClubEventResults+CoreDataProperties.h"
#import "CoreData/SwimClubAgeGroups+CoreDataClass.h"
#import "CoreData/SwimClubGroups+CoreDataClass.h"
#import "timeFunctions.h"
#import "resultsCell.h"

@interface resultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate> {
    
}
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) SwimClubEvents *myEvent;
@property (weak, nonatomic) IBOutlet UILabel *lblEvent;
@property (strong,nonatomic) NSMutableArray *myEventResults;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnsortImprovement;
@property (weak, nonatomic) IBOutlet UIButton *btnsortTime;
@property (strong, nonatomic) IBOutlet UITableView *tblResults;
@property (weak, nonatomic) IBOutlet UIToolbar *mytoolbar;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *tbTime;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *tbGroup;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *tbAge;

//-(IBAction)groupBy;
//- (IBAction)groupByAge;
//- (IBAction)groupByTime;
//- (IBAction)groupByGroup;
-(IBAction)groupBy:(UIBarButtonItem*)sender;

- (IBAction)sortBy:(id)sender;

@end

