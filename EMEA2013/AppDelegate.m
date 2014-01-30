//
//  AppDelegate.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "AppDelegate.h"
#import "Shared.h"
#import "Reachability.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Login.h"
#import "SyncUp.h"
#import "GlobalSearchViewController.h"
#import "User.h"
#import "AppSettings.h"
#import "Home.h"
#import "Functions.h"




@implementation AppDelegate

@synthesize def,scheduleData,RouteData,ShuttleScheduleLArrayobj,shuttleRouteArrayobj,shuttleInfoArrayobj,dictShuttleData;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    self.netStatus = [self.internetReachability currentReachabilityStatus];
	[self.internetReachability startNotifier];

    NSSetUncaughtExceptionHandler(&HandleUncaughtException);
    
    
    [self addBottomPullOutMenu];
    
    return YES;
}

- (void) reachabilityChanged:(NSNotification *)note
{
    self.internetReachability = [note object];
    self.netStatus = [self.internetReachability currentReachabilityStatus];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    //return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    return UIInterfaceOrientationMaskAll;
}

#pragma mark Register Notification Methods
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"Token: %@", deviceToken);
    
    Shared *objShared = [Shared GetInstance];
    [objShared SetDeviceToken:[[NSString alloc] initWithString:[NSString stringWithFormat:@"%@",deviceToken]]];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)data
{
    NSLog(@"%@",[data description]);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}
#pragma -

#pragma mark Exception Handler
void HandleUncaughtException(NSException *objException)
{
    [ExceptionHandler AddExceptionForScreen:@"" MethodName:@"Uncaught exception" Exception:[objException description]];
}

#pragma mark Bottom Menu
- (void) addBottomPullOutMenu
{
    //UIViewController *objRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    //objRootViewController = [Functions GetTopViewController:objRootViewController];
    
    //NSLog(@"%@",objRootViewController);
    
    //UIButton *btnOverlay = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.window.rootViewController.view.frame.size.width, self.window.rootViewController.view.frame.size.height)];
    //[btnOverlay setBackgroundColor:[UIColor redColor]];
    //[self.self.window.rootViewController.view addSubview:btnOverlay];
    
    CGFloat xOffset = 0;
    if([DeviceManager IsiPad] == YES)
    {
        xOffset = 352;
    }
    
    //NSLog(@"%d",[[[UIDevice currentDevice] systemVersion] integerValue]);
    pullUpView = [[StyledPullableView alloc] initWithFrame:CGRectMake(xOffset, 0, 320, self.window.rootViewController.view.frame.size.height)];
    if ([DeviceManager IsiPhone])
    {
        if([DeviceManager Is4Inch] == YES)
        {
            if([[DeviceManager GetDeviceSystemVersion] integerValue] < 7)
            {
                pullUpView.openedCenter = CGPointMake(160 + xOffset,self.window.rootViewController.view.frame.size.height + 185);
                pullUpView.closedCenter = CGPointMake(160 + xOffset, self.window.rootViewController.view.frame.size.height + 255);
            }
            else
            {
                pullUpView.openedCenter = CGPointMake(160 + xOffset,self.window.rootViewController.view.frame.size.height + 200);
                pullUpView.closedCenter = CGPointMake(160 + xOffset, self.window.rootViewController.view.frame.size.height + 270);
            }
        }
        else
        {
            if([[DeviceManager GetDeviceSystemVersion] integerValue] < 7)
            {
                pullUpView.openedCenter = CGPointMake(160 + xOffset,self.window.rootViewController.view.frame.size.height + 141);
                pullUpView.closedCenter = CGPointMake(160 + xOffset, self.window.rootViewController.view.frame.size.height + 211);
            }
            else
            {
                pullUpView.openedCenter = CGPointMake(160 + xOffset,self.window.rootViewController.view.frame.size.height + 155);
                pullUpView.closedCenter = CGPointMake(160 + xOffset, self.window.rootViewController.view.frame.size.height + 225);
            }
        }
    }
    else
    {
        pullUpView.openedCenter = CGPointMake(160 + xOffset,self.window.rootViewController.view.frame.size.height + 160);
        pullUpView.closedCenter = CGPointMake(160 + xOffset, self.window.rootViewController.view.frame.size.height + 220);
    }
    
    pullUpView.center = pullUpView.closedCenter;
    pullUpView.handleView.frame = CGRectMake(0, 0, 320, 40);
    pullUpView.delegate = self;
    [self.window.rootViewController.view addSubview:pullUpView];
}

- (void)hideBottomPullOutMenu
{
    [pullUpView setHidden:YES];
}

- (void)showBottomPullOutMenu
{
    [pullUpView setHidden:NO];
}
#pragma mark -

#pragma mark PullableView Events
- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened
{
    if(opened == YES)
    {
        //[self svwMain].frame = CGRectMake([self svwMain].frame.origin.x, [self svwMain].frame.origin.y, [self svwMain].frame.size.width, ([self svwMain].frame.size.height - [pView frame].size.height));
        //NSLog(@"%0.2f",[pView frame].size.height);
        //[self svwMain].contentSize = CGSizeMake([self svwMain].contentSize.width , ([self svwMain].contentSize.height - [pView frame].size.height));
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
    [(UINavigationController*)self.window.rootViewController pushViewController:vcSyncUp animated:YES];
}

- (void)pullableView:(PullableView *)pView loadSearch:(UITapGestureRecognizer *)gesture
{
    UIViewController *objVC = [Functions GetTopViewController:(UINavigationController*)self.window.rootViewController];
    
    if([objVC isKindOfClass:[GlobalSearchViewController class]])
    {
        return;
    }
    
    //[self performSegueWithIdentifier:@"loadSearch" sender:gesture];
    
    GlobalSearchViewController *vcGlobalSearchViewController;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcGlobalSearchViewController = [storyboard instantiateViewControllerWithIdentifier:@"idGlobalSearch"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcGlobalSearchViewController = [storyboard instantiateViewControllerWithIdentifier:@"idGlobalSearch"];
    }
    
    [(UINavigationController*)self.window.rootViewController pushViewController:vcGlobalSearchViewController animated:YES];
}

- (void)pullableView:(PullableView *)pView loadResources:(UITapGestureRecognizer *)gesture
{
    UIViewController *objVC = [Functions GetTopViewController:(UINavigationController*)self.window.rootViewController];
    
    //[svwMain setContentOffset:CGPointMake(1920.0f, svwMain.frame.origin.y) animated:YES];
    
    Home *vcHome;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcHome = [storyboard instantiateViewControllerWithIdentifier:@"idHome"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcHome = [storyboard instantiateViewControllerWithIdentifier:@"idHome"];
    }
    
    if([objVC isKindOfClass:[Home class]])
    {
        [((Home*)objVC) GoToLayerV1:1920.0f];
    }
    else
    {
        objVC = [Functions HasViewController:(UINavigationController*)self.window.rootViewController ViewController:vcHome];
        if(objVC != nil)
        {
            [(UINavigationController*)self.window.rootViewController popToViewController:objVC animated:YES];
            [((Home*)objVC) GoToLayerV1:1920.0f];
        }
        else
        {
            vcHome.intNavigateToTag = 1920.0f;
            [(UINavigationController*)self.window.rootViewController pushViewController:vcHome animated:YES];
        }
    }
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
    
    [(UINavigationController*)self.window.rootViewController pushViewController:vcLogin animated:YES];
}
#pragma mark -

#pragma mark logout Methods
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

#pragma -
@end
