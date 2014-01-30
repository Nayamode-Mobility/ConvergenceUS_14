//
//  Home.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 27/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Home.h"
#import "AppSettings.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Shared.h"
#import "User.h"
#import "FBJSON.h"
#import "SponsorsViewController.h"
#import "FAQViewController.h"
#import "Login.h"
#import "SyncUp.h"
#import "optin.h"
#import "AppDelegate.h"
#import "UIView+Custom.h"

@interface Home ()

@end

@implementation Home
#pragma mark Synthesize
@synthesize svwMain;
@synthesize liveClient;
#pragma mark -

#define SHOW_NEW_PERSON_VIEW_CONTROLLER true

#pragma mark View Events
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
    
	//Do any additional setup after loading the view.
    
  //  [self addBottomPullOutMenu];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_HOME];
    
    svwExhibitors.contentSize = CGSizeMake(svwExhibitors.frame.size.width, 750);
    //[UIView addTouchEffect:self.view];
    //[UIView addTouchEffectV1:self.view];
    
    if(self.intNavigateToTag > 0)
    {
        [self GoToLayerV1:self.intNavigateToTag];
        self.intNavigateToTag = 0;
    }
    
    [Analytics AddAnalyticsForScreen:strSCREEN_HOME];
    
    //[UIView addTouchEffect:self.view];
    //[UIView addTouchEffectV1:self.view];
    [UIView addTouchEffectV2:self.view];
    
    //[self addBottomPullOutMenu];
}


- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *objAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [objAppDelegate showBottomPullOutMenu];
}

-(void) addBottomPullOutMenu
{
    CGFloat xOffset = 0;
    if([DeviceManager IsiPad] == YES)
    {
        xOffset = 352;
    }
    
    //NSLog(@"%d",[[[UIDevice currentDevice] systemVersion] integerValue]);
    pullUpView = [[StyledPullableView alloc] initWithFrame:CGRectMake(xOffset, 0, 320, self.view.frame.size.height)];
    if ([DeviceManager IsiPhone])
    {
        if([DeviceManager Is4Inch] == YES)
        {
            if([[DeviceManager GetDeviceSystemVersion] integerValue] < 7)
            {
                pullUpView.openedCenter = CGPointMake(160 + xOffset,self.view.frame.size.height + 185);
                pullUpView.closedCenter = CGPointMake(160 + xOffset, self.view.frame.size.height + 255);
            }
            else
            {
                pullUpView.openedCenter = CGPointMake(160 + xOffset,self.view.frame.size.height + 200);
                pullUpView.closedCenter = CGPointMake(160 + xOffset, self.view.frame.size.height + 270);
            }
        }
        else
        {
            if([[DeviceManager GetDeviceSystemVersion] integerValue] < 7)
            {
                pullUpView.openedCenter = CGPointMake(160 + xOffset,self.view.frame.size.height + 141);
                pullUpView.closedCenter = CGPointMake(160 + xOffset, self.view.frame.size.height + 211);
            }
            else
            {
                pullUpView.openedCenter = CGPointMake(160 + xOffset,self.view.frame.size.height + 155);
                pullUpView.closedCenter = CGPointMake(160 + xOffset, self.view.frame.size.height + 225);
            }
        }
    }
    else
    {
        pullUpView.openedCenter = CGPointMake(160 + xOffset,self.view.frame.size.height + 160);
        pullUpView.closedCenter = CGPointMake(160 + xOffset, self.view.frame.size.height + 220);
    }
    
    pullUpView.center = pullUpView.closedCenter;
    pullUpView.handleView.frame = CGRectMake(0, 0, 320, 40);
    pullUpView.delegate = self;
    [self.view addSubview:pullUpView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(IBAction)btnInAppScanner_Click:(id)sender
{
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


- (IBAction)GoToLayer:(id)sender
{
    UIButton *btnSender = (UIButton*)sender;
    NSLog(@"%d",btnSender.tag);
    
   // if(btnSender.tag > 0)
   // {
     //   [svwMain setContentOffset:CGPointMake(btnSender.tag, svwMain.frame.origin.y) animated:YES];
   // }
    
    [self GoToLayerV1:btnSender.tag];
    
}

- (void)GoToLayerV1:(NSUInteger)intTag
{
    NSLog(@"%d",intTag);
    
    if(intTag > 0)
    {
        //[svwMain setContentOffset:CGPointMake(1920.0f, svwMain.frame.origin.y) animated:YES];
        [svwMain setContentOffset:CGPointMake(intTag, svwMain.frame.origin.y) animated:YES];
    }
}

/*
- (IBAction)LoadFAQ:(UIButton *)sender
{
    UIStoryboard *sb;
    if([DeviceManager IsiPad])
    {
        sb= [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    }
    else{
        sb= [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    }
    
    FAQViewController *vc = [sb instantiateViewControllerWithIdentifier:@"idFAQ"];
    
    [[self navigationController] pushViewController:vc animated:YES];
}
*/

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"loadTwitter"] || [identifier isEqualToString:@"loadFacebook"] || [identifier isEqualToString:@"loadLinkedin"] || [identifier isEqualToString:@"loadPhotoGallery1"] || [identifier isEqualToString:@"loadPhotoGallery2"] || [identifier isEqualToString:@"loadPhotoGallery3"] || [identifier isEqualToString:@"loadPhotoDetail"] || [identifier isEqualToString:@"loadTerms"] || [identifier isEqualToString:@"loadEvaluations"])
    {
//        Shared *objShared = [Shared GetInstance];
//        
//        if([objShared GetIsInternetAvailable] == NO)
//        {
//            [self showAlert:nil withMessage:strNoInternetError withButton:@"OK" withIcon:nil];
//            return NO;
//        }
        if (!APP.netStatus) {
            NETWORK_ALERT();
            return NO;
        }
    }
    
    return  YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*if ([segue.identifier isEqualToString:@"loadExhibitors"])
    {
        SponsorsViewController *controller = segue.destinationViewController;
        controller.blnIsExhibitors = YES;
    }
    else if ([segue.identifier isEqualToString:@"loadSponsors"])
    {
        SponsorsViewController *controller = segue.destinationViewController;
        controller.blnIsExhibitors = NO;
    }*/
    
    if ([segue.identifier isEqualToString:@"loadOptin"])
    {
        optin *vcOptin = segue.destinationViewController;
        vcOptin.blnCalledFromResources = YES;
    }
}
#pragma mark -

#pragma mark View Methods
- (void)configureLiveClientWithScopes
{
    if ([strLIVESDK_CLIENT_ID isEqualToString:@"%CLIENT_ID%"])
    {
        [NSException raise:NSInvalidArgumentException format:@"The CLIENT_ID value must be specified."];
    }
    
    self.liveClient = [[LiveConnectClient alloc] initWithClientId:strLIVESDK_CLIENT_ID
                                                           scopes:[strLIVESDK_SCOPES componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                                         delegate:nil
                                                        userState:strLIVESDK_INIT];
}

- (void) logout
{
    @try
    {
        [self.liveClient logoutWithDelegate:nil userState:strLIVESDK_LOGOUT];
    }
    @catch(id ex)
    {
        NSLog(@"Exception detail: %@", ex);
    }
}
#pragma mark -

#pragma mark PullableView Events
- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened
{
    if(opened == YES)
    {
        //[self svwMain].frame = CGRectMake([self svwMain].frame.origin.x, [self svwMain].frame.origin.y, [self svwMain].frame.size.width, ([self svwMain].frame.size.height - [pView frame].size.height));
        //NSLog(@"%0.2f",[pView frame].size.height);
        [self svwMain].contentSize = CGSizeMake([self svwMain].contentSize.width , ([self svwMain].contentSize.height - [pView frame].size.height));
    }
}

- (void)pullableView:(PullableView *)pView refreshData:(UITapGestureRecognizer *)gesture
{
    //SyncUp *objSyncUp = [[SyncUp alloc] init];
    //[objSyncUp SyncUp];
    
    SyncUp *vcSyncUp;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcSyncUp = [storyboard instantiateViewControllerWithIdentifier:@"idSyncUp"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcSyncUp = [storyboard instantiateViewControllerWithIdentifier:@"idSyncUp"];
    }
    
    vcSyncUp.blnCalledFromHome = YES;
    [[self navigationController] pushViewController:vcSyncUp animated:YES];
}

- (void)pullableView:(PullableView *)pView loadSearch:(UITapGestureRecognizer *)gesture
{
    [self performSegueWithIdentifier:@"loadSearch" sender:gesture];
}

- (void)pullableView:(PullableView *)pView loadResources:(UITapGestureRecognizer *)gesture
{
   // [svwMain setContentOffset:CGPointMake(1920.0f, svwMain.frame.origin.y) animated:YES];
     [self GoToLayerV1:1920.0f];
    
}

- (void)pullableView:(PullableView *)pView logout:(UITapGestureRecognizer *)gesture
{
    User *objUser = [User GetInstance];
    [objUser ClearUserInfo];
    
    AppSettings  *objAppSettings = [AppSettings GetInstance];
    [objAppSettings ClearAppSettings];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:strUSER_DEFAULT_KEY_USER_INFO];
    
    [self configureLiveClientWithScopes];
    [self logout];
    
    Login *vcLogin;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcLogin = [storyboard instantiateViewControllerWithIdentifier:@"idLogin"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcLogin = [storyboard instantiateViewControllerWithIdentifier:@"idLogin"];
    }
    
    [[self navigationController] pushViewController:vcLogin animated:YES];
}


#pragma mark -

@end
