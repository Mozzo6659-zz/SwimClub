//
//  membersViewController.h
//  SwimClub
//
//  Created by Mick Mossman on 5/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/SwimClubEvents+CoreDataClass.h"
#import <CoreData/CoreData.h>
#import "CoreDataError.h"
#import "CoreData/SwimClubMembers+CoreDataClass.h"
#import "CoreData/SwimClubEventResults+CoreDataClass.h"
#import "timeFunctions.h"
#import "addMemberViewController.h"

@interface membersViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
}

//@property (weak, nonatomic) id<RBAddSelectionsDelegate> adddelegate;

@property (strong, nonatomic) IBOutlet UITableView *mytableview;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong,nonatomic) SwimClubEvents *selectedEvent;

@end
