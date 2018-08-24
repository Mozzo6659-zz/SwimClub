//
//  adjustEstimateViewController.m
//  SwimClub
//
//  Created by Mick Mossman on 16/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import "adjustEstimateViewController.h"

@interface adjustEstimateViewController ()

@end


@implementation adjustEstimateViewController
@synthesize selectedEventResults;
@synthesize lblName;
@synthesize lblDistance;
@synthesize txtHours;
@synthesize txtMinutes;
@synthesize txtSeconds;
@synthesize managedObjectContext;
@synthesize imgMemberPhoto;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self loadNavItems];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) loadNavItems {
    //[self.navigationItem setTitle:@"Add Member"];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Verdana" size:30];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textColor = [UIColor whiteColor];
    label.text = @"Adjust Estimate";
    self.navigationItem.titleView = label;
    
    [self.navigationItem setHidesBackButton:true animated:NO];
    
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"<< Done"
                                 style:UIBarButtonItemStyleDone
                                 target:self
                                 action:@selector(goback)];
    
    [self.navigationItem setLeftBarButtonItem:backitem animated:YES];
   
    
}
- (IBAction)takePhoto:(UIButton *)sender {
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
-(void)goback {
    NSString *serr = [self validateEntry];
    if (serr==nil) {
        [txtSeconds resignFirstResponder];
        [txtMinutes resignFirstResponder];
        [txtHours resignFirstResponder];
        [self saveItem];
        [self resetVars];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self showError:serr];
    }
}

-(void)resetVars {
    selectedEventResults = nil;
}
-(void)saveItem {
    NSManagedObjectContext *context = self.managedObjectContext;
    timeFunctions *f = [[timeFunctions alloc] init];
    NSString *thetime =[NSString stringWithFormat:@"%02d:%02d:%02d",[txtHours.text intValue], [txtMinutes.text intValue], [txtSeconds.text intValue]];
    selectedEventResults.expectedseconds = [f convertTimeToSeconds:thetime];
    [self addPhoto];
    
    NSError *error;
    if (![context save:&error]) {
        CoreDataError *err = [[CoreDataError alloc] init];
        //NSLog(@"Error: %@",[error description]);
        [err showError:error];
    }
   
}

-(void)addPhoto {
    if (img != nil && bAddPhoto) {
        
        int memid = (int) self.selectedEventResults.memberid;
        
        
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
-(NSString*)validateEntry {
    NSString *err;
    timeFunctions *f = [[timeFunctions alloc] init];
    
    int hrs = [txtHours.text intValue];
    int mins = [txtMinutes.text intValue];
     int secs = [txtHours.text intValue];
    if (hrs==0 && mins==0 && secs==0) {
        err = @"Invalid Time";
    }
    if (err==nil) {
        err= [f validateMinutesSeconds:mins];
        if (err==nil) {
            err= [f validateMinutesSeconds:secs];
        }
    }
    
    
    return err;
    
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
-(void)configureView {
    [self.navigationController setNavigationBarHidden:false];
    timeFunctions *f = [[timeFunctions alloc] init];
    NSString *estTime = [f convertSecondsToTime:selectedEventResults.expectedseconds];
    NSArray *splitTime = [estTime componentsSeparatedByString: @":"];
    txtHours.text = splitTime[0];
    txtMinutes.text = splitTime[1];
    txtSeconds.text = splitTime[2];
    
    CGFloat rad = 30;
    
    lblDistance.layer.cornerRadius = rad ;
    lblName.layer.cornerRadius = rad;
    lblName.text = selectedEventResults.member.membername;
   // NSLog(@"evname=%@",selectedEventResults.event.eventname);
    NSString *dist = [[NSString alloc] initWithFormat:@"%d (mtrs)",selectedEventResults.event.distancemtrs];
    
    lblDistance.text = dist;
                        
                        
    [txtMinutes becomeFirstResponder];
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
