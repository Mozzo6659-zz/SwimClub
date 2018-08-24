//
//  addMemberViewController.h
//  SwimClub
//
//  Created by Mick Mossman on 3/12/17.
//  Copyright © 2017 Mick Mossman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/SwimClubMembers+CoreDataClass.h"
#import "CoreData/SwimClubGroups+CoreDataClass.h"
#import "CoreDataError.h"
#import "timeFunctions.h"
#import "CommonFunctions.h"
#include <CoreGraphics/CGGeometry.h>

@interface addMemberViewController : UIViewController  <UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UITextFieldDelegate> {
    BOOL showExtraDetails;
    BOOL bAddPhoto;
    UIImagePickerController *picker;
    UIImage *img;
    
    
}

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtKHours;
@property (weak, nonatomic) IBOutlet UITextField *txtKMinutes;
@property (weak, nonatomic) IBOutlet UITextField *txtKSeconds;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property (weak, nonatomic) IBOutlet UIView *vwExtraDetails;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnMale;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@property (strong, nonatomic) timeFunctions *timefun;
@property(nonatomic, assign) BOOL quickEntry;
@property (strong,nonatomic) SwimClubMembers *selectedMember;
@property (strong,nonatomic) SwimClubGroups *selectedgrp;
@property (weak, nonatomic) IBOutlet UITextField *txtDOBday;
@property (weak, nonatomic) IBOutlet UITextField *txtDOBmonth;
@property (weak, nonatomic) IBOutlet UITextField *txtDOByear;
@property (weak, nonatomic) IBOutlet UILabel *lblGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnGroup;


- (IBAction)selectGroup:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *pkrGroup;

- (IBAction)hideKeyBoard:(id)sender;


- (IBAction)btnMFClick:(id)sender;

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIImageView *imgMemberPhoto;

@property (weak, nonatomic) IBOutlet UIButton *btnTakePhoto;

- (IBAction)saveMember:(id)sender;
@end
