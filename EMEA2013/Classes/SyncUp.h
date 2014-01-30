//
//  SyncUp.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 27/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyncUp : UIViewController
{
    IBOutlet UIActivityIndicatorView *avLoading;
    
     NSMutableArray *arrExecuteQuery;
     NSMutableArray *arrInternetAccess;
}

@property (nonatomic, retain) UIActivityIndicatorView *avLoading;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

@property (nonatomic) BOOL blnCalledFromHome;

- (void)SyncUp;
- (void)loadHome;
-(void)GetShuttleInfo:(NSData*) objShuttleData;
-(void)GetInternetAccessData;


///Sushma
@property (strong, nonatomic) IBOutlet UILabel *lblText;

@end
