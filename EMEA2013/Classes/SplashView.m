//
//  ViewController.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "SplashView.h"
#import "User.h"
#import "AppSettings.h"
#import "Shared.h"
#import "DeviceManager.h"
#import "Constants.h"
#import "Login.h"
#import "SyncUp.h"
#import "Home.h"
#import "DB.h"
#import "NSString+Custom.h"

@interface SplashView ()

@end

@implementation SplashView

#pragma mark Synthesize
@synthesize avLoading;
#pragma mark -

#pragma mark View Events
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /*for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }*/
    
    [[self avLoading] startAnimating];
    [self CopyDB];
    [self CopyPList];
    [self performSegueWithIdentifier:@"loadLogin" sender:nil];
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
#pragma mark -

#pragma mark Segue's
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"loadLogin"])
    {
        //[self performSelector:@selector(loadLogin) withObject:nil afterDelay:4];
        [self loadLogin];
    }
}
#pragma mark -

#pragma mark Connections Events
#pragma mark -

#pragma mark View Methods
- (void)CopyDB
{
    BOOL blnFirstTimeUse = NO;
    
	//Look in Documents for an existing database file
	NSArray *arrPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *strDocumentsDirectory = [arrPaths objectAtIndex:0];
	
	NSString *strUserDocumentsPath = [strDocumentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.sqlite", @"EMEAFY14"]];
    
	//If it's not there, copy it from the bundle
	NSFileManager *fileManger = [NSFileManager defaultManager];
	if (![fileManger fileExistsAtPath:strUserDocumentsPath])
	{
		NSString *strBundlePath = [[NSBundle mainBundle] pathForResource:@"EMEAFY14" ofType:@"sqlite"];
		
		// Copy the database from the package to the users filesystem
		[fileManger copyItemAtPath: strBundlePath toPath: strUserDocumentsPath error: nil];
        
        blnFirstTimeUse = YES;
	}
    DB *objDB = [DB GetInstance];
    [objDB SetDatabasePath:strUserDocumentsPath];
    
    Shared *objShared = [Shared GetInstance];
    [objShared SetFirstTimeUse:blnFirstTimeUse];
}

- (void)CopyPList
{
	//Look in Documents for an existing plist file
	NSArray *arrPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *strDocumentsDirectory = [arrPaths objectAtIndex:0];
	
	NSString *strUserDocumentsPath = [strDocumentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.plist", @"AppSettings"]];
    
	//If it's not there, copy it from the bundle
	NSFileManager *fileManger = [NSFileManager defaultManager];
	if (![fileManger fileExistsAtPath:strUserDocumentsPath])
	{
		NSString *strBundlePath = [[NSBundle mainBundle] pathForResource:@"AppSettings" ofType:@"plist"];
		
		// Copy the plist from the package to the users filesystem
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:strBundlePath];
		[dictPList writeToFile:strUserDocumentsPath atomically:YES];
	}
    
    Shared *objShared = [Shared GetInstance];
    [objShared SetPListPath:strUserDocumentsPath];
}

- (void)loadLogin
{
    //[self loadHome];
    
    AppSettings *objAppSettings = [AppSettings GetInstance];
    if([NSString IsEmpty:[objAppSettings GetAccountEmail] shouldCleanWhiteSpace:YES])
    {
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

        [[self avLoading] stopAnimating];
        [[self navigationController] pushViewController:vcLogin animated:YES];
    }
    else
    {
        User *objUser = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:strUSER_DEFAULT_KEY_USER_INFO]];
        [User SetUserObject:objUser];
        NSLog(@"%@",[objUser GetAccountEmail]);
     
    
        [self loadSyncup];
    }
}

- (void)loadHome
{
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
    
    [[self navigationController] pushViewController:vcHome animated:YES];
}

- (void)loadSyncup
{
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
    
    [[self navigationController] pushViewController:vcSyncUp animated:YES];
}
#pragma mark -
@end
