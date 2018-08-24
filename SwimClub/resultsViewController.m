//
//  resultsViewController.m
//  SwimClub
//
//  Created by Mick Mossman on 12/12/17.
//  Copyright © 2017 Hammerhead Software. All rights reserved.
//

#import "resultsViewController.h"

@interface resultsViewController ()

@end

@implementation resultsViewController
@synthesize myEvent;
@synthesize lblEvent;
@synthesize lblLocation;
@synthesize btnsortTime;
@synthesize btnsortImprovement;
@synthesize tblResults;
@synthesize mytoolbar;
@synthesize myEventResults;
@synthesize fetchedResultsController = __fetchedResultsController;
//@synthesize tbAge; not using age for result grouping
@synthesize tbTime;
@synthesize tbGroup;

//tells the sort within each group
NSString *resultCol = @"resultseconds";
NSString *improveCol = @"diffseconds";
NSString *lastsortCol;
//Tells what we are grouping the table sections by
NSString *sectionItem = @"";
NSString *sectionItemTime = @"TIME";
NSString *sectionItemGroup = @"GROUP";
NSString *sectionItemAge = @"AGE";

//NSMutableArray *myEventResults;
NSMutableArray *tblsections;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self loadAgeGroups];
    [self configureView];
    [self loadNavItems];
    
    lastsortCol = resultCol;
    [self changeBtnColour:lastsortCol];
    
    sectionItem = sectionItemTime;
    [tbTime setTintColor:[UIColor orangeColor]];
    
    [tblResults setEstimatedSectionHeaderHeight:10.0];
    
    self.fetchedResultsController.delegate = self;
    self.tblResults.delegate = self;
    self.tblResults.dataSource = self;
   
    //tblResults.dataSource = __fetchedResultsController;
    
    //tblResults.delegate=self;
    
    
    //[tblResults reloadData];
    //tblResults = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    
    
    //[self maketablecontents:YES sortColumn:resultCol groupColumn:sectionItemTime];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) loadNavItems {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    
    label.font = [UIFont fontWithName:@"Verdana" size:30];
    
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textColor = [UIColor whiteColor];
    label.text = @"Event";
    
    self.navigationItem.titleView = label;
    
    /*Hide otherwise you get 2 back buttns*/
    [self.navigationItem setHidesBackButton:true animated:NO];
    
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"<< Home"
                                 style:UIBarButtonItemStyleDone
                                 target:self
                                 action:@selector(goHome)];
    
    [self.navigationItem setLeftBarButtonItem:backitem animated:YES];

}


-(void)configureView {
    lblLocation.text = myEvent.location;
    NSString *eventdetails = [NSString stringWithFormat:@"%d",myEvent.distancemtrs];
    eventdetails = [eventdetails stringByAppendingString:@" mtrs "];
    
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    [f2 setDateFormat:@"dd-MM-YYYY"];
    NSString *s = [f2 stringFromDate:myEvent.eventdate];
    eventdetails = [eventdetails stringByAppendingString:s];
    
     [self.navigationController setNavigationBarHidden:false];
    lblEvent.text = eventdetails;
    lblLocation.layer.cornerRadius = 30; //Make sure Clip subviews is on
    lblEvent.layer.cornerRadius = 30;
    btnsortTime.layer.cornerRadius = 30;
    btnsortImprovement.layer.cornerRadius = 30;
    
   /*
    UIBarButtonItem *tbTime = [self makeToolbarButtonFromImage:@"timeglyph" title:@"Time" mytag:1];
    UIBarButtonItem *tbAge = [self makeToolbarButtonFromImage:@"ageglyph" title:@"Age" mytag:2];
    UIBarButtonItem *tbGroup = [self makeToolbarButtonFromImage:@"groupglyph" title:@"Group" mytag:3];
    */
    /*
    tbTime = [self makeToolbarButtonFromImage:@"timeglyph" title:@"Time" mytag:1];
    tbAge = [self makeToolbarButtonFromImage:@"ageglyph" title:@"Age" mytag:2];
    tbGroup = [self makeToolbarButtonFromImage:@"groupglyph" title:@"Group" mytag:3];
   
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    self.mytoolbar.items = [NSArray arrayWithObjects:tbTime,flexible, tbAge,flexible, tbGroup,flexible, nil];
*/
} 

-(UIBarButtonItem*)makeToolbarButtonFromImage:(NSString*)imgname title:(NSString*) thetitle mytag:(int)thetag {
    /*NOT USING THIS FUNCTION ANYMORE LEAVE FOR TIME BEING
     IT PUTS TXT TO THE RIGHT AND IN WHITE (EVEN IF I ASK FOR BLACK) BUT I NEED THE BUTTON AS AN OUTLET TO CHANGE TINT COLOUR*/
    /*
    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatButton setBackgroundImage:chatImage forState:UIControlStateNormal];
    [chatButton setTitle:@"Chat" forState:UIControlStateNormal];
    chatButton.frame = (CGRect) {
        .size.width = 100,
        .size.height = 30,
    };
    */
    NSString *imgnormal = imgname;
    //NSString *imgselect = imgname;
    
    imgnormal = [imgnormal stringByAppendingString:@".png"];
    //imgselect = [imgselect stringByAppendingString:@"_orange.png"];
    
    UIImage *imagenormal = [UIImage imageNamed:imgnormal];
    //UIImage *imageselect = [UIImage imageNamed:imgselect];
    
   
    //UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithImage:imagenormal style:UIBarButtonItemStylePlain target:self action:@selector(groupByTime)];
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button setImage:imagenormal forState:UIControlStateNormal];
    [button setBackgroundImage:imagenormal forState:UIControlStateNormal];
    //[button setImage:imageselect forState:UIControlStateSelected]; //THIS DIDTN WORJ USE TINTCOLOR FOR UIButtonbarItems
    
    [button setTitle:thetitle forState:UIControlStateNormal];
    //[button setTitle:thetitle forState:UIControlStateSelected];
    [button addTarget:self action:@selector(groupBy:) forControlEvents:UIControlEventTouchUpInside];
    /*
    if ([thetitle isEqualToString:@"Time"]) {
       [button addTarget:self action:@selector(groupByTime) forControlEvents:UIControlEventTouchUpInside];
    }else{
        if ([thetitle isEqualToString:@"Age"]) {
            [button addTarget:self action:@selector(groupByAge) forControlEvents:UIControlEventTouchUpInside];
        }else {
             [button addTarget:self action:@selector(groupByGroup) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    */
    button.bounds = CGRectMake( 0, 0, 80, 80 );
    [button sizeToFit];
    //button.titleLabel.textColor = UIColor.blackColor;
    button.tag = thetag;
    
    //button.showsTouchWhenHighlighted = YES;
    
    
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];;
    
}

-(void)goHome {
    
    [self resetVars];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)resetVars {
    tblResults = nil;
   myEventResults = nil;
   tblsections = nil;
    myEvent = nil;
    __fetchedResultsController = nil;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)groupByTime {
    sectionItem = sectionItemTime;
    [self reloadTable];
}
-(IBAction)groupByAge {
    sectionItem = sectionItemAge;
    [self reloadTable];
}
-(IBAction)groupByGroup {
    sectionItem = sectionItemGroup;
    [self reloadTable];
}
-(void)reloadTable {
    __fetchedResultsController = nil;
    
    [tblResults reloadData];
    //[self.tblResults refreshControl];
    //[tblResults reloadSectionIndexTitles];
    //NSIndexSet *thesections = [[NSIndexSet alloc] init];
    /*if you dont do this then the tableview doesnt refresh the sections*/
    NSRange range = NSMakeRange(0, self.fetchedResultsController.sections.count-1);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    [tblResults reloadSections:section withRowAnimation:UITableViewRowAnimationFade];
    /*
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
     */
}


 -(IBAction)groupBy:(UIBarButtonItem*)sender {

     
     //sender.tintColor= UIColor.orangeColor;
     //tbTime.tintColor = UIColor.orangeColor;
     //NSLog(@"tag=%ld",sender.tag);
     //[tbAge setTintColor:mytoolbar.tintColor];
     [tbTime setTintColor:mytoolbar.tintColor];
     [tbGroup setTintColor:mytoolbar.tintColor];
     //if ([sender isEqual:tbAge]) {
         //sectionItem = sectionItemAge;
         
     //}else {
         if ([sender isEqual:tbGroup]) {
             sectionItem = sectionItemGroup;
             
         }else{
            sectionItem = sectionItemTime;
             
         }
     //}
     
    
     [sender setTintColor:[UIColor orangeColor]];
     
     [self reloadTable];
     
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = @"";
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    if ([self isinGroupMode]) {
        title= [self getGroupName:[sectionInfo.name intValue]];
    }else{
       title = sectionInfo.name;
    }
    
    /*
     NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
     sections = [sections sortedArrayUsingDescriptors:@[sd]];
     return [sections objectAtIndex:section];
     */
    return title;
}
-(NSString*)getGroupName: (int)theid {
    NSString *grpname;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *pred;
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity;
    
    
    if ([sectionItem isEqualToString:sectionItemAge]) {
        entity = [NSEntityDescription
                                       entityForName:@"AgeGroups" inManagedObjectContext:context];
        pred = [NSPredicate predicateWithFormat:@"agegroupid=%d",theid];
    }else{
        if ([sectionItem isEqualToString:sectionItemGroup]) {
            entity = [NSEntityDescription
                      entityForName:@"Groups" inManagedObjectContext:context];
             pred = [NSPredicate predicateWithFormat:@"groupid=%d",theid];
        }
    }
   
    [fetchRequest setEntity:entity];
    
    
    [fetchRequest setPredicate:pred];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count != 0) {
        if ([sectionItem isEqualToString:sectionItemAge]) {
            for (SwimClubAgeGroups *ag in fetchedObjects) {
                grpname = ag.agegroupname;
                break;
            }
        }else{
            for (SwimClubGroups *grp in fetchedObjects) {
                grpname = grp.groupname;
                break;
            }
        }
        
    }
    return grpname;
}
- (IBAction)sortBy:(id)sender {
    NSString *colToSort;
    if ([sender isEqual:btnsortTime]) {
        colToSort = resultCol;
    }else {
        colToSort = improveCol;
    }
    //[self maketablecontents:YES sortColumn:colToSort groupColumn:sectionItem];
    lastsortCol = colToSort;
    [self changeBtnColour:colToSort];
    
    [self reloadTable];
   
}


#pragma mark - Tableview stuff-


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numRows = 0;
    
    if ([self isinGroupMode]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numRows = [sectionInfo numberOfObjects];
    }else{
        //NSLog(@"gpcnt=%lu",self.fetchedResultsController.sections.count);
        numRows = self.fetchedResultsController.fetchedObjects.count;
    }
    
    
    return numRows;
    
}

-(UIView  *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    int offset = 5;
    
    UIView* headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width - (offset * 2), 100)];
    //NSLog(@"svc=%lu",[headerView.subviews count]);
    if (![self isinGroupMode]) {
        headerView.backgroundColor = UIColor.clearColor;
        //headerView = nil;
    }else{
        headerView.backgroundColor = UIColor.blackColor;
        
        //headerView = [[UIView alloc] initWithFrame:CGRectMake(offset, offset, tableView.bounds.size.width - (offset * 2), 100)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, tableView.bounds.size.width,  25)];
        //label.clipsToBounds=YES;
        
        //label.layer.cornerRadius = 10;
        //CALayer *l = [label layer];
        
        label.backgroundColor = UIColor.blackColor;
        label.textColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Verdana" size:25.0];
        
        label.text = [tblResults.dataSource tableView:tblResults titleForHeaderInSection:section];
        
        //NSLog(@"text=%@",label.text);
        
        
        [headerView addSubview:label];

    }

    return headerView;
    
}
-(BOOL)isinGroupMode {
    if ([sectionItem isEqualToString:sectionItemTime]) {
        return NO;
    }else{
        return YES;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numSections=0;
    
    if ([self isinGroupMode]) {
        numSections = [[self.fetchedResultsController sections] count];
    }else{
        numSections = 1;
    }
    
    return numSections;
    
    
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    resultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[resultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resultsCell"];
    }else {
        cell.layer.cornerRadius = 8;
    }
    
    
    [self configureCell:cell atIndexPath:indexPath];
    
    //NSLog(@"celltext=%@ hidden=%d",cell.lbltbEstCell.text,cell.lbltbEstCell.hidden);
    return cell;
}

- (void)configureCell:(resultsCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    UIImageView *imageView;
    //NSInteger theindex  = indexPath.row + indexPath.section;
    NSInteger theindex  = indexPath.row;
  
    
    //NSLog(@"IP section=%ld row=%ld count=%lu",indexPath.section,indexPath.row,self.fetchedResultsController.fetchedObjects.count);
    
    SwimClubEventResults *lh = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    //NSLog(@"name=%@ at Row %lu",lh.member.membername,indexPath.row);
    
    timeFunctions *f = [[timeFunctions alloc] init];
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:35.0];
    //cell.detailTextLabel.font = [UIFont fontWithName:@"Verdana" size:20.0];
    
    NSString *textlabel = lh.member.membername;
    textlabel = [textlabel stringByAppendingFormat:@"   Age: %d",lh.member.age];
    
    NSString *estLabel = @"Est:";
    estLabel = [estLabel stringByAppendingString:[f convertSecondsToTime:lh.expectedseconds]];
    
    NSString *resultlabel = @"Result:";
   resultlabel = [resultlabel stringByAppendingString:[f convertSecondsToTime:lh.resultseconds]];
    
    
    NSString *improvelabel = @"Diff:";
    
    improvelabel = [improvelabel stringByAppendingString:[f convertSecondsToTime:abs(lh.diffseconds)]];
    
   cell.lblheader.text = textlabel;
    
    cell.lbltbEstCell.text = estLabel;
    cell.lbltbresult.text = resultlabel;
    //[cell.lbltbimprove setHidden:NO];
    
    cell.lbltbimprove.layer.cornerRadius=10;
    if (lh.diffseconds < 0) {
        
        cell.lbltbimprove.backgroundColor =[UIColor greenColor];
    }else {
        cell.lbltbimprove.backgroundColor =[UIColor redColor];
    }
    cell.lbltbimprove.text = improvelabel;
    
    
    /*Setthe medals*/
    if (theindex==0) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gold7575.png"]];
        
    }else {
        if (theindex==1) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"silver7575.png"]];
        }else {
            if (theindex==2) {
                imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bronze7575.png"]];
            }
        }
    }
    
    if (imageView != nil) {
        cell.accessoryView = imageView;
        [imageView sizeToFit];
    }else{
        cell.accessoryView=nil;
    }
    

}

/*
-(void) maketablecontents:(BOOL) reset sortColumn:(NSString*)sortCol groupColumn:(NSString*)groupcol {
 
    
    //NSArray *sortedArray = [myEventResults sortedArrayUsingDescriptors:@[sortDescriptor]];
    sectionItem = groupcol;
    lastsortCol = sortCol;
    NSSortDescriptor *sortDescriptor;
    NSArray *sdesc;
    NSManagedObjectContext *context = self.managedObjectContext;
   
    if (myEventResults==nil || reset) {
        myEventResults = [[NSMutableArray alloc] init];
    }
    
    for (SwimClubEventResults *ev in myEvent.eventResults) {
        if (ev.resultseconds!=0) {
            
            if ([sectionItem isEqualToString:sectionItemAge]) {
                //need to add the age group to the member
                SwimClubMembers *mem = ev.member;
                SwimClubAgeGroups *ag = [self getAgeGroup:mem.age];
                mem.agegroup = ag;
                NSError *error;
                
                if (![context save:&error]) {
                    CoreDataError *err = [[CoreDataError alloc] init];
                    [err showError:error];
                }
            }
            
            [myEventResults addObject:ev];
        }
    }
    
    if ([myEventResults count] !=0) {
        if ([sectionItem isEqualToString:sectionItemAge] || [sectionItem isEqualToString:sectionItemGroup]) {
            NSSortDescriptor *sortDescriptor1;
            NSSortDescriptor *sortDescriptor2;
            if ([sectionItem isEqualToString:sectionItemGroup]) {
                sortDescriptor1  = [[NSSortDescriptor alloc] initWithKey:@"member.membergroup.groupname" ascending:YES];
            }else {
               sortDescriptor1  = [[NSSortDescriptor alloc] initWithKey:@"member.agegroup.agegroupname" ascending:YES];
            }
            sortDescriptor2  = [[NSSortDescriptor alloc] initWithKey:sortCol ascending:YES];
            sdesc = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor2,nil];
        }else {
           sortDescriptor  = [[NSSortDescriptor alloc] initWithKey:sortCol ascending:YES];
            sdesc = [[NSArray alloc] initWithObjects:sortDescriptor,nil];
        }
       //
    
        //NSArray *sdesc = [[NSArray alloc] initWithObjects:sortDescriptor,nil];
        
        [myEventResults sortUsingDescriptors:sdesc];
        
        //[self createSections];
        
        [self changeBtnColour:sortCol];
        
        
    }
    
    
}
 */
/*
-(void) createSections  {
    tblsections = [[NSMutableArray alloc] init];
    
    if ([sectionItem isEqualToString:sectionItemGroup]) {
        for (SwimClubEventResults *ev in myEventResults) {
            NSString *gritem = ev.member.membergroup.groupname;
            [self addToSectionArray:gritem];
        }
    }else {
        if ([sectionItem isEqualToString:sectionItemAge]) {
            for (SwimClubEventResults *ev in myEventResults) {
                NSString *gritem = ev.member.agegroup.agegroupname;
                [self addToSectionArray:gritem];
            }
        }
    }
}
-(NSInteger)numberOfRowsInSection: (NSString*)sectionItem {
    NSInteger numRows = 0;
    
    if ([sectionItem isEqualToString:sectionItemGroup]) {
        for (SwimClubEventResults *ev in myEventResults) {
            NSString *gritem = ev.member.membergroup.groupname;
            if ([gritem isEqualToString:sectionItem]) {
                numRows += 1;
            }
        }
    }else {
        if ([sectionItem isEqualToString:sectionItemAge]) {
            for (SwimClubEventResults *ev in myEventResults) {
                NSString *gritem = ev.member.agegroup.agegroupname;
                if ([gritem isEqualToString:sectionItem]) {
                    numRows += 1;
                }
            }
        }else {
            numRows += 1;
        }
    }
    
    return numRows;
}
-(void)addToSectionArray: (NSString*) theitem {
    BOOL bfound = NO;
    for (NSString *item in tblsections) {
        if ([item isEqualToString:theitem]) {
            bfound = YES;
            break;
        }
    }
    if (!bfound) {
        [tblsections addObject:theitem];
    }
}
 */
-(void)changeBtnColour: (NSString*) sortCol {
    UIColor *btnColor = [[UIColor alloc ] initWithRed:0.0 green:1.0 blue:1.0 alpha:1.0];
    //UIColor *btnColor = [[UIColor alloc ] initWithRed:111.0 green:214.0 blue:255.0 alpha:0.1];
    UIColor *btnSelColor = [[UIColor alloc ] initWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];
    
    if ([sortCol isEqualToString:resultCol]) {
        btnsortTime.backgroundColor=btnSelColor;
        btnsortImprovement.backgroundColor = btnColor;
    }else {
        btnsortTime.backgroundColor=btnColor;
        btnsortImprovement.backgroundColor = btnSelColor;
    }
}

//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    //[self.tblResults beginUpdates];
//}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSArray *sortDescriptors;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = self.managedObjectContext;
    // Edit the entity name as appropriate.
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EventResults" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"eventid=  %d",myEvent.eventid];
    
    //NSLog(@"eventid=%d",myEvent.eventid);
    
    [fetchRequest setPredicate:pred];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    //NSString *sectionKey=nil;
    NSString *sectionsortKey=nil;
    //if ([sectionItem isEqualToString:sectionItemTime]) {
        //sectionKey = @"memberid";
   // }else {
    
    
    if ([self isinGroupMode]) {
        if ([sectionItem isEqualToString:sectionItemAge]) {
            //sectionKey = @"member.agegroup.agegroupname";
            sectionsortKey = @"member.agegroup.agegroupid";
        }else{
            //sectionKey = @"member.membergroup.groupname"; //cant use this if I want it to sort correctly within groups. First sort descriptor must be the table group
            sectionsortKey = @"member.membergroup.groupid";
        }
    }
    
    NSSortDescriptor *rowsortDescriptor = [[NSSortDescriptor alloc] initWithKey:lastsortCol ascending:YES];
    
    if (sectionsortKey != nil) {
        NSSortDescriptor *sectionsortDescriptor = [[NSSortDescriptor alloc] initWithKey:sectionsortKey ascending:YES];
        sortDescriptors = [NSArray arrayWithObjects:sectionsortDescriptor,rowsortDescriptor, nil];
        
        
    }else{
      sortDescriptors = [NSArray arrayWithObjects:rowsortDescriptor, nil];
        
    }
    
   [fetchRequest setSortDescriptors:sortDescriptors];
   
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:sectionsortKey cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    __fetchedResultsController = aFetchedResultsController;
    
    /*
    __fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:sectionKey cacheName:nil];
    */
    __fetchedResultsController.delegate = self;
    
    
    NSError *error = nil;
    if (![__fetchedResultsController performFetch:&error]) {
        CoreDataError *err = [[CoreDataError alloc] init];
        [err showError:error];
    }
    //NSLog(@"rows=%lu",__fetchedResultsController.fetchedObjects.count);
    return __fetchedResultsController;
}
@end
