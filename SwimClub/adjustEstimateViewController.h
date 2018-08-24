//
//  adjustEstimateViewController.h
//  SwimClub
//
//  Created by Mick Mossman on 16/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreData/SwimClubEventResults+CoreDataClass.h"
#import "CoreData/SwimClubEvents+CoreDataProperties.h"
#import "CoreData/SwimClubMembers+CoreDataClass.h"
#import "CoreDataError.h"
#import "timeFunctions.h"
#import "CommonFunctions.h"
@interface adjustEstimateViewController : UIViewController <UIImagePickerControllerDelegate, UITextFieldDelegate> {
    BOOL bAddPhoto;
    UIImagePickerController *picker;
    UIImage *img;
}
@property (weak,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) SwimClubEventResults *selectedEventResults;

@property (weak, nonatomic) IBOutlet UILabel *lblDistance;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextField *txtHours;
@property (weak, nonatomic) IBOutlet UITextField *txtMinutes;
@property (weak, nonatomic) IBOutlet UITextField *txtSeconds;
@property (weak, nonatomic) IBOutlet UIImageView *imgMemberPhoto;
@end

