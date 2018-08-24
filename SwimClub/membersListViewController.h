//
//  membersListViewControllerTableViewController.h
//  SwimClub
//
//  Created by Mick Mossman on 14/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataError.h"
#import "CoreData/SwimClubMembers+CoreDataClass.h"
#import "addMemberViewController.h"
#import "timeFunctions.h"
#import "CommonFunctions.h"
@interface membersListViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
}
@property (weak,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UITableView *mytableview;
@property (strong,nonatomic) SwimClubMembers *selectedMember;

@end
