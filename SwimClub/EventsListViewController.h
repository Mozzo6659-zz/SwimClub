//
//  EventsListViewController.h
//  SwimClub
//
//  Created by Mick Mossman on 14/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreData/SwimClubEvents+CoreDataClass.h"
#import "CoreData/SwimClubMembers+CoreDataClass.h"
#import "CoreDataError.h"
#import "eventViewController.h"
#import "resultsViewController.h"
@interface EventsListViewController : UITableViewController <NSFetchedResultsControllerDelegate>  {
    
}
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong,nonatomic) SwimClubEvents *selectedEvent;
@property (strong, nonatomic) IBOutlet UITableView *mytableview;
@property(nonatomic, assign) BOOL showFinished;

@end
