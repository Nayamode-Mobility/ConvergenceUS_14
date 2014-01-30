//
//  AttendeeViewController.m
//  mgx2013
//
//  Created by Amit Karande on 04/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//
#import "AttendeeViewController.h"
#import "AttendeeDetailViewController.h"
#import "CustomCollectionViewCell.h"
#import "DeviceManager.h"
#import "Functions.h"
#import "AttendeeDB.h"
#import "Attendee.h"
#import "MasterDB.h"
#import "Categories.h"
#import "NSString+Custom.h"
#import "User.h"
#import "DB.h"
#import "NSURLConnection+Tag.h"
#import "ExhibitorDB.h"
#import "Shared.h"
#import "AppDelegate.h"

@interface AttendeeViewController ()
{
    @private
    NSString *vCardString;
}
@end

#define SHOW_NEW_PERSON_VIEW_CONTROLLER true

@implementation AttendeeViewController
#pragma mark Synthesize
@synthesize objConnection, objData, dictData;
#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    arrAlphabets = [[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    
    
    [[[self btnSearch] layer] setBorderWidth:2.0f];
    [[[self btnSearch] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnSearch] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnSearch] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnRefresh] layer] setBorderWidth:2.0f];
    [[[self btnRefresh] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnRefresh] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnRefresh] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnContactExchange] layer] setBorderWidth:2.0f];
    [[[self btnContactExchange] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self avContactExchange] setHidden:YES];
    [[self avContactExchange] stopAnimating];
    
    if (self.arrAttendees == nil)
    {
        self.arrAttendees = [[NSArray alloc] init];
    }
    
//    AttendeeDB *objAttendee = [AttendeeDB GetInstance];
//    self.arrAttendees = [objAttendee GetAttendees];
    
//    if([self DataExists] == NO) Commented by Nikhil
//    {
//        [self SyncAttendees];
//    }
    
    if (self.arrCategories == nil)
    {
        self.arrCategories = [[NSArray alloc] init];
    }

//    MasterDB *objMaster = [MasterDB GetInstance];
//    self.arrCategories = [objMaster GetCategories];
    
    self.blnDropdownExpanded = NO;
    [self setBorders];
    
    [self.svwAttendees setContentSize:CGSizeMake(320, self.svwAttendees.frame.size.height)];
    [self.svwAttendees setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_ATTENDEE];
    
    //[UIView addTouchEffect:self.view];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if([DeviceManager IsiPad] == YES)
    {
        //return UIInterfaceOrientationMaskAll;
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == [self txtSearch])
    {
        //[[self txtSearch] resignFirstResponder];
        [self btnSearchClicked:[self btnSearch]];
    }
    
    return  YES;
}

- (BOOL)DataExists
{
    BOOL blnDataExists = NO;
    
    if([[self arrAttendees] count] > 0)
    {
        blnDataExists = YES;
    }
    
    return blnDataExists;
}

- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)GetAttendeesOfCharacter:(NSString*)strCharacter
{
   // Shared *objShared = [Shared GetInstance];
    
//    if([objShared GetIsInternetAvailable] == NO)
//    {
//        [self showAlert:nil withMessage:strNoInternetError withButton:@"OK" withIcon:nil];
//        return;
//    }
    if (APP.netStatus) {
    
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
        strURL = [strURL stringByAppendingString:@"api/Attendee/GetAttendeeListByCharacter"];//api/Attendee/GetAttendeeListByCharacter
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_ATTENDEE]] forHTTPHeaderField:@"VersionNo"];
    [objRequest addValue:strCharacter forHTTPHeaderField:@"Character"];
        
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_ANTENDEE_LIST];
    }else{
        NETWORK_ALERT();
    }
}

- (void)SyncAttendeeExhibitor
{
    //Shared *objShared = [Shared GetInstance];
    
//    if([objShared GetIsInternetAvailable] == NO)
//    {
//        [self showAlert:nil withMessage:strNoInternetError withButton:@"OK" withIcon:nil];
//        return;
//    }
    if (APP.netStatus) {
  
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    ExhibitorDB *objExhibitorDB = [ExhibitorDB GetInstance];
    NSString *strAttendeeExhibitors = [objExhibitorDB GetAttendeeExhibitorsJSON];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_EXHIBITOR_GET_ATTENDEE_EXHIBITOR_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:strAttendeeExhibitors forHTTPHeaderField:@"ExhibitorJSON"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_ATTENDEE_EXHIBITOR]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_ATTENDEE_EXHIBITOR_LIST];
    }else{
        NETWORK_ALERT();
    }
}

- (void)SetAttendees
{
    AttendeeDB *objAttendeeDB = [[AttendeeDB alloc] init];
    self.arrAttendees = [objAttendeeDB GetAttendeesList:objData];
}

- (void)SetAttendeeExhibitors
{
    AttendeeDB *objAttendeeDB = [[AttendeeDB alloc] init];
    BOOL blnResult = [objAttendeeDB SetAttendeeExhibitors:objData];
    NSLog(blnResult?@"Attendee Exhibitor: YES":@"Attendee Exhibitor: NO");
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if(view.tag == 1)
    {
        return [arrAlphabets count];
    }
    else if(view.tag == 2)
    {
        return [self.arrAttendeesFiltered count];
    }
    else
    {
        if([[self arrAttendees] count] > 0)
        {
            //return [[[self.arrAttendees objectAtIndex:self.intSelectedIndex] objectAtIndex:1] count];
            return [self.arrAttendees count];
        }
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cv.tag == 1)
    {
        cell.articleTitle.text = [arrAlphabets objectAtIndex:indexPath.row];// [[NSString stringWithFormat:@"%@",[[self.arrAttendees objectAtIndex:(indexPath.row)] objectAtIndex:0]] lowercaseString];
    }
    else
    {
        Attendee *objAttendee;
        
        if(cv.tag == 2)
        {
            objAttendee = [self.arrAttendeesFiltered objectAtIndex:indexPath.row];
        }
        else
        {
            objAttendee = [self.arrAttendees objectAtIndex:indexPath.row];// [[[self.arrAttendees objectAtIndex:self.intSelectedIndex] objectAtIndex:1] objectAtIndex:indexPath.row];
        }
        
        cell.lblName.text = [NSString stringWithFormat:@"%@ %@",objAttendee.strFirstName,objAttendee.strLastName];
        cell.lblTitle.text = objAttendee.strAttendeeName;
        cell.lblTitle.textColor = [UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0];
        cell.lblCompany.text = objAttendee.strCompany;
        cell.cellData = objAttendee;
        
        cell.imgLogo.image = nil;
        cell.imgLogo.image = [UIImage imageNamed:@"normal.png"];
        if(![NSString IsEmpty:objAttendee.strPhotoURL shouldCleanWhiteSpace:YES])
        {
            NSURL *imgURL = [NSURL URLWithString:objAttendee.strPhotoURL];
            NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
            [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
            NSData *data,
            NSError *error)
            {
                if (!error)
                {
                    //NSLog(@"%@ %@",response.URL.absoluteString,((Attendee*)cell.cellData).strPhotoURL);
                    if([response.URL.absoluteString isEqualToString:((Attendee*)cell.cellData).strPhotoURL])
                    {
                    cell.imgLogo.image = [UIImage imageWithData:data];
                }
            }
            }];
        }
    }
    
    //[UIView addTouchEffect:cell.contentView];

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1)
    {
        [[self txtSearch] setText:@""];
        [self.txtSearch resignFirstResponder];
        
        [[self attendeeFilteredCollectionView] setHidden:YES];
        [[self attendeeCollectionView] setHidden:NO];
        
        self.arrAttendeesFiltered = nil;
        
        self.intSelectedIndex = indexPath.row;
        //[self.attendeeCollectionView reloadData];
        
        [self.svwAttendees setContentSize:CGSizeMake(640, self.svwAttendees.frame.size.height)];
        [self.svwAttendees setContentOffset:CGPointMake(320, 0) animated:YES];
        
        [self GetAttendeesOfCharacter:[arrAlphabets objectAtIndex:indexPath.row]];
    }
    
    //[self performSegueWithIdentifier:@"loadSponsorDetail" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.arrCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Categories *objCategories = [self.arrCategories objectAtIndex:indexPath.row];
    
    //VenueFloorPlan *objVenueFloorPlan = [self.arrFloorPlans objectAtIndex:indexPath.row];
    cell.textLabel.text = objCategories.strCategoryName;//[NSString stringWithFormat:@"Track %d",indexPath.row];//objVenueFloorPlan.strBriefDescription;
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(104/255.0) green:(33/255.5) blue:0 alpha:1];
    cell.selectedBackgroundView = selectionColor;
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self ShrinkView];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.blnDropdownExpanded = NO;
    Categories *objCategories = [self.arrCategories objectAtIndex:indexPath.row];
    self.lblSelectedCategory.text = objCategories.strCategoryName;
    //[self setFloorPlanData:indexPath.row];
}


#pragma mark View Methods
- (IBAction)showDropdownMenu:(id)sender {
    if (self.blnDropdownExpanded) {
        [self ShrinkView];
        self.blnDropdownExpanded = NO;
    }
    else{
        UIButton *clickedButton = (UIButton *)sender;
        [self expandView:clickedButton.tag];
        self.blnDropdownExpanded = YES;
    }
    
}

- (void)expandView:(NSInteger)tag {
    NSInteger intExpandHeight = 200;
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        self.vwCategoryDropdown.frame = CGRectMake(self.vwCategoryDropdown.frame.origin.x, self.vwCategoryDropdown.frame.origin.y, (self.vwCategoryDropdown.frame.size.width), intExpandHeight);
        
    } completion:nil];
    
}

- (void)ShrinkView
{
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        self.vwCategoryDropdown.frame = CGRectMake(self.vwCategoryDropdown.frame.origin.x, self.vwCategoryDropdown.frame.origin.y, (self.vwCategoryDropdown.frame.size.width), 0);
    } completion:nil];
    //blnViewExpanded = NO;
}

-(void)setBorders{
    [self setBorderToView:self.vwCategoryDropdown];
}

-(void)setBorderToView:(UIView *)view{
    [[view layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[view layer] setBorderWidth:1.5];
    //[[self.vwTracksDropdown layer] setCornerRadius:10];
    [view setClipsToBounds: YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"loadAttendeeDetail1"] || [segue.identifier isEqualToString:@"loadAttendeeDetail2"])
    {
        AttendeeDB *objAttendeeDB = [AttendeeDB GetInstance];
        
        AttendeeDetailViewController *controller = segue.destinationViewController;
        CustomCollectionViewCell *attendeeCell = (CustomCollectionViewCell *)sender;
        controller.attendeeData = (Attendee *)attendeeCell.cellData;
        controller.attendeeData.strIsNotesAvailable = [NSString stringWithFormat:@"%hhd",[objAttendeeDB CheckAvailableAttendeeNotes:controller.attendeeData.strEmail]];

    }
}

- (IBAction)btnBackClicked:(id)sender
{
    //NSLog(@"%f",[svwAttendees contentOffset].x);
    if([self.svwAttendees contentOffset].x == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if ([DeviceManager IsiPhone])
        {
            [self.svwAttendees setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.txtSearch resignFirstResponder];
}

- (IBAction)btnRefreshClicked:(id)sender
{
    //Do not remove the search for 4 spaces
    //[[self txtSearch] setText:@"    "];
    
    //[self btnSearchClicked:[self btnSearch]];
    
    //[[self txtSearch] setText:@""];
    
    [self.txtSearch resignFirstResponder];
    
    //[self SyncAttendees];
}

- (IBAction)btnSearchClicked:(id)sender
{
    [[self lblNoItemsFound] setHidden: YES];
    
    //Min. 3 charecters need to be searched
    if(self.txtSearch.text.length < 3)
    {
        if(self.txtSearch.text.length == 0)
        {
            [self.txtSearch resignFirstResponder];
        }

        [self showAlert:@"" withMessage:@"Please enter valid attendee name to search the attendee. Minimum search text length is 3." withButton:@"OK" withIcon:nil];
        
        return;
    }
    
    [[self txtSearch] resignFirstResponder];
    
    if (self.arrAttendeesFiltered == nil)
    {
        self.arrAttendeesFiltered = [[NSArray alloc] init];
    }
    
    AttendeeDB *objAttendeeDB = [AttendeeDB GetInstance];
    
    //self.arrAttendees = [objAttendeeDB GetAttendeesLikeName:self.txtSearch.text];
    self.arrAttendeesFiltered = [objAttendeeDB GetAttendeesLikeNameAndGrouped:self.txtSearch.text blnGrouped:NO];
    
    //self.intSelectedIndex = -1;
    
    if([self.arrAttendeesFiltered count] == 0)
    {
        //[self.svwAttendees setContentSize:CGSizeMake(320, self.svwAttendees.frame.size.height)];
        //[self.svwAttendees setContentOffset:CGPointMake(0, 0) animated:YES];
        
        [[self lblNoItemsFound] setHidden:NO];
        
        //[self.colAttendeesAlphabets setHidden:YES];
        //[self.btnContactExchange setHidden:YES];
        
        [[self attendeeFilteredCollectionView] setHidden:YES];
        [[self attendeeCollectionView] setHidden:YES];
        
        [self.svwAttendees setContentSize:CGSizeMake(640, self.svwAttendees.frame.size.height)];
        [self.svwAttendees setContentOffset:CGPointMake(320, 0) animated:YES];
    }
    else
    {
        //[self.svwAttendees setContentSize:CGSizeMake(320, self.svwAttendees.frame.size.height)];
        //[self.svwAttendees setContentOffset:CGPointMake(0, 0) animated:YES];
        
        //[self.colAttendeesAlphabets setHidden:NO];
        //[self.btnContactExchange setHidden:NO];
        
        //[self.colAttendeesAlphabets reloadData];
        
        [[self attendeeFilteredCollectionView] setHidden:NO];
        [[self attendeeCollectionView] setHidden:YES];
        
        [self.attendeeFilteredCollectionView reloadData];
        
        [self.svwAttendees setContentSize:CGSizeMake(640, self.svwAttendees.frame.size.height)];
        [self.svwAttendees setContentOffset:CGPointMake(320, 0) animated:YES];
    }
}

- (IBAction)btnContactExchangeClicked:(id)sender
{
    //NSLog(@"Scanning..");
    
    [[self avContactExchange] setHidden:NO];
    [[self avContactExchange] startAnimating];
    
    ZBarReaderViewController *codeReader = [ZBarReaderViewController new];
    codeReader.readerDelegate = self;
    codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = codeReader.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    
    [self presentViewController:codeReader animated:YES completion:nil];
}

- (void)showAlert:(NSString*)titleMsg withMessage:(NSString*)alertMsg withButton:(NSString*)btnMsg withIcon:(NSString*)imagePath
{
	UIAlertView *currentAlert	= [[UIAlertView alloc]
                                   initWithTitle:titleMsg
                                   message:alertMsg
                                   delegate:nil
                                   cancelButtonTitle:btnMsg
                                   otherButtonTitles:nil];
    
	[currentAlert show];
	
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    if (person != NULL)
    {
        [self addvCardInContact];
    }
    else
    {
        [[self avContactExchange] setHidden:YES];
        [[self avContactExchange] stopAnimating];
    }
}

-(void)addvCardInContact
{
    CFErrorRef error = nil;
    //NSLog(@"%@", @"add vcard contact");
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL)
    {
        //We're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        //We're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted)
    {
        ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, &error);;
        BOOL addedinContact=NO;
        // This line converts the string to a CFData object using a simple cast, which doesn't work under ARC
        CFDataRef vCardData = (__bridge CFDataRef)[vCardString dataUsingEncoding:NSUTF8StringEncoding];
        
        ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(iPhoneAddressBook);
        CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vCardData);
        for (CFIndex index = 0; index < CFArrayGetCount(vCardPeople); index++)
        {
            ABRecordRef person = CFArrayGetValueAtIndex(vCardPeople, index);
            ABAddressBookAddRecord(iPhoneAddressBook, person, NULL);
            //CFRelease(person);
            addedinContact=YES;
        }
        
        CFRelease(vCardPeople);
        CFRelease(defaultSource);
        
        ABAddressBookSave(iPhoneAddressBook, &error);
        //CFRelease(vCardData);
        CFRelease(iPhoneAddressBook);
        
        if (error != NULL)
        {
            CFStringRef errorDesc = CFErrorCopyDescription(error);
            //NSLog(@"Contact not saved: %@", errorDesc);
            CFRelease(errorDesc);
        }
        else
        {
            if (addedinContact)
            {
                //NSLog(@"saved");
                [self showAlert:@"" withMessage:@"Contact saved to your phone book." withButton:@"OK" withIcon:nil];
            }
            else
            {
                [self showAlert:@"" withMessage:@"Could not scan the card." withButton:@"OK" withIcon:nil];
                //UIAlertView *alertError=[[UIAlertView alloc] initWithTitle:nil message:@"Invalid vCard" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                //[alertError show];
            }
        }
    }
    else
    {
        //NSLog(@"Address book access not provided");
        [self showAlert:@"" withMessage:@"Application does not have permission to access your phone book." withButton:@"OK" withIcon:nil];
    }
    
    [[self avContactExchange] setHidden:YES];
    [[self avContactExchange] stopAnimating];
}

#pragma mark ZBar SDK Events
- (void) imagePickerController:(UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary*) info
{
    //  get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // just grab the first barcode
        break;
    
    // showing the result on textview
    //self.resultTextView.text = symbol.data;
    
    vCardString=symbol.data;
    //NSLog(@"%@",vCardString);
    
    //self.resultImageView.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    //[self addinContact];
    // dismiss the controller
    [reader dismissViewControllerAnimated:YES completion:^
    {
        if(SHOW_NEW_PERSON_VIEW_CONTROLLER)
        {
            CFErrorRef error = nil;
            ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, &error);;
            BOOL addedinContact=NO;
            // This line converts the string to a CFData object using a simple cast, which doesn't work under ARC
            CFDataRef vCardData = (__bridge CFDataRef)[vCardString dataUsingEncoding:NSUTF8StringEncoding];
            
            ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(iPhoneAddressBook);
            CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vCardData);
            
            
            for (CFIndex index = 0; index < CFArrayGetCount(vCardPeople); index++)
            {
                ABRecordRef person = CFArrayGetValueAtIndex(vCardPeople, index);
                ABAddressBookAddRecord(iPhoneAddressBook, person, NULL);
                ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init];
                view.newPersonViewDelegate = self;
                view.displayedPerson = person;
                [self.navigationController setNavigationBarHidden:NO];
                [self.navigationController pushViewController:view animated:YES];
                //CFRelease(person);
                addedinContact=YES;
            }
            
            CFRelease(vCardPeople);
            CFRelease(defaultSource);
        }
        else
        {
            [self addvCardInContact];
            //NSLog(@"%@", @"add contact");
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[self avContactExchange] setHidden:YES];
    [[self avContactExchange] stopAnimating];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    objData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [objData appendData:data];
    
    /*NSInteger intTag = (int)[connection getTag];
     NSNumber *tag = [NSNumber numberWithInteger:intTag];
     
     if([dictData objectForKey:tag] == nil)
     {
     NSMutableData *newData = [[NSMutableData alloc] initWithData:data];
     [dictData setObject:newData forKey:tag];
     return;
     }
     else
     {
     [[dictData objectForKey:tag] appendData:data];
     }*/
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSInteger intTag = (int)[connection getTag];
    //NSLog(@"Connection Tag: %d",intTag);
    
    NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@",strData);
    
    switch (intTag)
    {
        case OPER_GET_ANTENDEE_LIST:
            {
                [self SetAttendees];
                //[self SyncAttendeeExhibitor];
                //AttendeeDB *objAttendee = [AttendeeDB GetInstance];
                //self.arrAttendees = [objAttendee GetAttendees];
                
                [self.attendeeCollectionView reloadData];
                //[self.colAttendeesAlphabets reloadData];
                [[self vwLoading] setHidden:YES];
                [[self avLoading] stopAnimating];

            }
            break;
        case OPER_GET_ATTENDEE_EXHIBITOR_LIST:
            {
                [self SetAttendeeExhibitors];
                
                if(self.txtSearch.text.length < 3)
                {
                    AttendeeDB *objAttendee = [AttendeeDB GetInstance];
                    self.arrAttendees = [objAttendee GetAttendees];
                    
                    [self.colAttendeesAlphabets reloadData];
                }
                else
                {
                    [self btnSearchClicked:[self btnSearch]];
                }
                
                [[self vwLoading] setHidden:YES];
                [[self avLoading] stopAnimating];
            }
            break;
        default:
            break;
    }
}
#pragma mark -
@end
