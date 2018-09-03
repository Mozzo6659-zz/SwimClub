//
//  addMemberViewController.m
//  SwimClub
//
//  Created by Mick Mossman on 3/12/17.
//  Copyright © 2017 Mick Mossman. All rights reserved.
//

#import "addMemberViewController.h"


@interface addMemberViewController ()

@end


@implementation addMemberViewController
@synthesize selectedMember;
@synthesize txtKHours;
@synthesize txtKMinutes;
@synthesize txtKSeconds;
@synthesize txtName;
@synthesize txtEmail;
@synthesize timefun;
@synthesize btnSave;
@synthesize quickEntry;
@synthesize vwExtraDetails;
@synthesize txtDOBday;
@synthesize txtDOByear;
@synthesize txtDOBmonth;
@synthesize lblGroup;
@synthesize btnGroup;
@synthesize pkrGroup;
@synthesize btnMale;
@synthesize btnFemale;
@synthesize selectedgrp;
@synthesize imgMemberPhoto;


NSMutableArray *pickerdata;
//CGRect origframe;
//CGRect newframe;
UITextField *txtcurrent;

- (void)viewDidLoad {
    bAddPhoto = NO;
    [super viewDidLoad];
    [self configureView];
    
    [self loadNavItems];
    timefun = [[timeFunctions alloc] init];
    
    if (selectedMember==nil) {
        selectedgrp = pickerdata[0];
        [self startNewMember];
        //[btnSave setHidden:quickEntry];
    }else{
        //NSLog(@"onek=%d",selectedMember.onekseconds);
        [self showSelectedMember];
        //[btnSave setHidden:YES];
    }
    
    // Do any additional setup after loading the view.
}
-(void)configureView {
    
    [txtName becomeFirstResponder];
    [self.navigationController setNavigationBarHidden:false];
    
    
    btnSave.layer.cornerRadius = 40;
    btnGroup.layer.cornerRadius = 10;
    lblGroup.layer.cornerRadius = 20;
    
    [vwExtraDetails setHidden:quickEntry];
    pickerdata = [[NSMutableArray alloc] init];
    [self loadPickerData];
    self.pkrGroup.delegate = self;
    self.pkrGroup.dataSource= self;
    
    [pkrGroup setHidden:YES];
    
    
}


#pragma picker view
-(void)loadPickerData {
    if ([pickerdata count]==0) {
        NSManagedObjectContext *context = self.managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Groups" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"groupid" ascending:YES]];
        NSError *error;
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        if (fetchedObjects.count != 0) {
            
            for (SwimClubGroups *grp in fetchedObjects) {
                [pickerdata addObject:grp];
                
            }
        
        }
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //NSLog(@"cnt=%lu",[pickerdata count]);
    return [pickerdata count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
     SwimClubGroups *grp = pickerdata[row];
    //NSLog(@"%@",grp.groupname);
    return grp.groupname;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectGroup:(id)sender {
    [self removeKeyBoard];
    CGPoint pnt = lblGroup.center;
    pnt.x = pnt.x - 60.0f;
    pnt.y = pnt.y + 60.0f;
    pkrGroup.center = pnt;
    [pkrGroup setHidden:NO];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component; {
    SwimClubGroups *grp = pickerdata[row];
    
        selectedgrp = grp;
    lblGroup.text = grp.groupname;
    [pkrGroup setHidden:YES];
    
    
}

- (IBAction)hideKeyBoard:(id)sender {
    [self removeKeyBoard];
}

- (IBAction)btnMFClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    UIButton *otherbtn;
    
    if(btn==btnMale) {
        otherbtn = btnFemale;
    }else {
        otherbtn = btnMale;
    }
    
    if(btn.tag==0) {
        [btn setImage:[self getTickedImage] forState:UIControlStateNormal];
        btn.tag = 1;
        [otherbtn setImage:[self getUnTickedImage] forState:UIControlStateNormal];
        otherbtn.tag = 0;
    }else{
        [btn setImage:[self getUnTickedImage] forState:UIControlStateNormal];
        btn.tag = 0;
        [otherbtn setImage:[self getTickedImage] forState:UIControlStateNormal];
        otherbtn.tag = 1;
    }
}

-(UIImage*) getTickedImage {
    UIImage *btnTickedImage = [UIImage imageNamed:@"tickbox.png"];
    return btnTickedImage;
}
-(UIImage*) getUnTickedImage {
    UIImage *btnUnTickedImage = [UIImage imageNamed:@"openbox.png"];
    return btnUnTickedImage;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
   UILabel* tView = (UILabel*)view;
    if (!tView){
        
        tView = [[UILabel alloc] init];
        
        [tView setFont:[UIFont fontWithName:@"Verdana" size:25.0]];
        tView.textAlignment = NSTextAlignmentCenter;
        
    }
    // Fill the label text here
    SwimClubGroups *grp = pickerdata[row];
    tView.text = grp.groupname;
    
    return tView;
}

#pragma keyboard show hide frame
/*
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    txtcurrent = textField;
    
    return YES;
}
*/
/*
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}
*/
/*
- (void)keyboardDidShow:(NSNotification *)notification
{
    
    if ([txtcurrent isEqual:txtEmail] || [txtcurrent isEqual:txtDOBday] || [txtcurrent isEqual:txtDOBmonth] | [txtcurrent isEqual:txtDOByear]) {
        [self.view setFrame:newframe];
    }
}
 */
/*
-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:origframe];
}
 */
-(void)showSelectedMember {
    txtName.text = selectedMember.membername;
    txtEmail.text = selectedMember.emailaddress;
    if ([selectedMember.gender isEqualToString:@"Male"]) {
        [btnMale setImage:[self getTickedImage] forState:UIControlStateNormal];
        [btnFemale setImage:[self getUnTickedImage] forState:UIControlStateNormal];
        btnFemale.tag=0;
        btnMale.tag = 1;
    }else{
        [btnMale setImage:[self getUnTickedImage] forState:UIControlStateNormal];
        [btnFemale setImage:[self getTickedImage] forState:UIControlStateNormal];
        btnFemale.tag=1;
        btnMale.tag = 0;
    }
    //NSLog(@"onek=%d",selectedMember.onekseconds);
    NSString *onektime = [timefun convertSecondsToTime:selectedMember.onekseconds];
    //NSLog(@"again onek=%d",selectedMember.onekseconds);
    NSArray *thetime = [onektime componentsSeparatedByString: @":"];
    txtKHours.text = thetime[0];
    txtKMinutes.text = thetime[1];
    txtKSeconds.text = thetime[2];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSString *birthday = [dateFormat stringFromDate:selectedMember.dateofbirth];
    NSArray *thedatesplit = [birthday componentsSeparatedByString:@"/"];
    
    txtDOByear.text = thedatesplit[2];
    txtDOBmonth.text = thedatesplit[1];
    txtDOBday.text = thedatesplit[0];
    
    selectedgrp = selectedMember.membergroup;
    lblGroup.text = selectedgrp.groupname;
    CommonFunctions *mysettings = [[CommonFunctions alloc] init];
    
    NSString *photoname = [mysettings makePhotoName:selectedMember.memberid];
    NSString *imgFilePath = [mysettings getFullPhotoPath:photoname];
    
    [imgMemberPhoto setImage:[UIImage imageWithContentsOfFile:imgFilePath]];
  
   
}

-(void)startNewMember {
    
    txtName.text = @"";
    txtKHours.text = @"00";
    txtKMinutes.text = @"20";
    txtKSeconds.text = @"00";
    
    txtEmail.text = @"";
    txtDOBday.text = @"";
    txtDOBmonth.text = @"";
    txtDOByear.text = @"";
    img = nil;
    [imgMemberPhoto setImage:nil];
    [txtName becomeFirstResponder];
    //selectedgrp = pickerdata[0];
    lblGroup.text = selectedgrp.groupname;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
    if ([segue.identifier isEqualToString:@"ADDMEMBER"]) {
        
        addMemberViewController *controller = [segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
    }
     */
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void) removeKeyBoard {
    [self.view endEditing:YES];
    /*
    [txtName resignFirstResponder];
    [txtKSeconds resignFirstResponder];
    [txtKMinutes resignFirstResponder];
    [txtKHours resignFirstResponder];
    [txtDOByear resignFirstResponder];
    [txtDOBday resignFirstResponder];
    [txtDOBmonth resignFirstResponder];
     */
   
}

-(bool) validateEventDetails {
    
    NSString *errmsg;
    
    NSString *hrTime = txtKHours.text;
    NSString *minTime = txtKMinutes.text;
    NSString *secTime = txtKSeconds.text;
    
    
    NSString *memname = txtName.text;
    
    if ([memname length]==0) {
        errmsg = @"Name is required";
    }
    
    if(btnFemale.tag==0 && btnMale.tag==0) {
        errmsg = @"Please select a gender";
    }
    
    if ([hrTime intValue]==0 && [minTime intValue]==0 && [secTime intValue] ==0) {
        errmsg = @"One K time is invalid";
        
    }
    
    if (errmsg==nil) {
        
        errmsg = [timefun validateMinutesSeconds:[minTime intValue]];
        
        if (errmsg==nil) {
            errmsg = [timefun validateMinutesSeconds:[secTime intValue]];
        }
    }
    
    if (errmsg==nil) {
        //check the birthdate is ok
        if ([txtDOBday.text length] > 2) {
            errmsg = @"Invalid DOB";
        }
        if ([txtDOBmonth.text length] > 2) {
            errmsg = @"Invalid DOB";
        }
        if ([txtDOByear.text length] != 4) {
            errmsg = @"Please enter full four digit year ";
        }
        if (errmsg==nil) {
            if (![timefun isValidDate:[txtDOBday.text intValue] themonth:[txtDOBmonth.text intValue] theyear:[txtDOByear.text intValue]]) {
                errmsg = @"Invalid DOB";
            }
        }
        
    }
    if (errmsg != nil) {
        [self showError:errmsg];
    }
    
    return (errmsg==nil);
}

-(NSString*)makeFullDate {
    return [NSString stringWithFormat:@"%02d/%02d/%04d",[txtDOBday.text intValue],
            [txtDOBmonth.text intValue],[txtDOByear.text intValue]];
    
   
}
-(void)showError:(NSString*)msg {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:^{}];
}
- (IBAction)saveMember:(id)sender {
    
    if ([self validateEventDetails]) {
        NSManagedObjectContext *context = self.managedObjectContext;
        NSString *thetime = [NSString stringWithFormat:@"%02d:%02d:%02d",[txtKHours.text intValue], [txtKMinutes.text intValue], [txtKSeconds.text intValue]];
        
        NSString *DOB = [NSString stringWithFormat:@"%02d/%02d/%04d",[txtDOBday.text intValue], [txtDOBmonth.text intValue], [txtDOByear.text intValue]];
        //NSLog(@"%@",DOB);
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];// here set format which you want...
        NSDate *memDOB = [dateFormat dateFromString:DOB];
        
        if(selectedMember==nil) {
            NSInteger nextid = [self getNextId];
            SwimClubMembers *mem  = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Members"
                                           inManagedObjectContext:context];
            
            mem.memberid = (int) nextid;
            mem.membername = txtName.text;
            mem.emailaddress = txtEmail.text;
            mem.onekseconds = [timefun convertTimeToSeconds:thetime];
            mem.webid = 0;
            mem.dateofbirth = memDOB;
            mem.membergroup = selectedgrp;
            if (quickEntry) { //quickentry s from the event entry window so select the dude for the event
                 mem.selectedforevent=1;
            }else{
                 mem.selectedforevent=0;
            }
           
            //NSLog(@"age=%d",mem.age);
            if (btnMale.tag==1) {
                mem.gender=@"Male";
            }else {
                mem.gender=@"Female";
            }
            [self adPhoto:mem.memberid];
        } else {
            selectedMember.membername = txtName.text;
            selectedMember.emailaddress = txtEmail.text;
            selectedMember.onekseconds = [timefun convertTimeToSeconds:thetime];
            selectedMember.datachanged = 1;
            selectedMember.dateofbirth = memDOB;
            if (btnMale.tag==1) {
                selectedMember.gender=@"Male";
            }else {
                selectedMember.gender=@"Female";
            }
            selectedMember.membergroup = selectedgrp;
            [self adPhoto:selectedMember.memberid];
        }
        
        NSError *error;
        if (![context save:&error]) {
            CoreDataError *err = [[CoreDataError alloc] init];
            //NSLog(@"Error: %@",[error description]);
            [err showError:error];
        }else{
            //if a member is selected to be editied then exit window if ot tem clear and start a new entry
            if (selectedMember==nil) {
                [self startNewMember];
            }else{
                [self goback];
            }
            
        }
    }
}

-(NSInteger)getNextId {
    NSInteger nextid = 1;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Members" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    fetchRequest.fetchLimit = 1;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"memberid" ascending:NO]];

    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        
        for (SwimClubMembers *mem in fetchedObjects) {
            nextid = mem.memberid;
            nextid += 1;
            
        }
    }
    
    //NSLog(@"memberid %d",(int) nextid);
    return nextid;

        
}

-(void) loadNavItems {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Verdana" size:30];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textColor = [UIColor whiteColor];
    label.text = @"Add Member";
    self.navigationItem.titleView = label;
    
    [self.navigationItem setHidesBackButton:true animated:NO];
    
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"<< Back"
                                 style:UIBarButtonItemStyleDone
                                 target:self
                                 action:@selector(goback)];
    
     
    
    
    [self.navigationItem setLeftBarButtonItem:backitem animated:YES];
    
    
    
}


-(void)goback {
    /*
    BOOL doSave = YES;
    if (selectedMember != nil || quickEntry) {
        //if quick entry dont dave if no name entered
        NSString *memname = txtName.text;
        
        if ([memname length]==0) {
            doSave = NO;
        }
        if (doSave) {
            [self saveMember:self];
        }
        
        
    }
     */
    quickEntry = NO;
    selectedMember=nil;
    selectedgrp=nil;
    [self.navigationController popViewControllerAnimated:NO];
}


/********************************
 PHOTOS
 ********************************/

-(IBAction)takePhoto:(id)sender {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.imgMemberPhoto setImage:img];
    [self dismissViewControllerAnimated:YES completion:nil];
    bAddPhoto = YES;
    
}

- (void)adPhoto:(int) memid {
    
    /*only for testing on simulator cuz  cant take a photo*/
    //img = self.imgPhotoView.image;
    
    if (img != nil && bAddPhoto) {
        
        //int memid = (int) self.selectedMember.memberid;
        
        
        CommonFunctions *mysettings = [[CommonFunctions alloc] init];
        //NSLog(@"memid=%d",memid);
              
        NSString *photoname = [mysettings makePhotoName:memid];
        
        NSString *fullfileandpath = [mysettings getFullPhotoPath:photoname];
        //NSLog(@"%@",fullfileandpath);
        //NSLog(@"savedath=%@",fullfileandpath);
        
        NSData *data = UIImageJPEGRepresentation(img,1.0);
        
        [data writeToFile:fullfileandpath atomically:YES];
        
       
        
        
        bAddPhoto = NO;
    }
}


/*********************************
 END PHOTOS
 *********************************/
@end
