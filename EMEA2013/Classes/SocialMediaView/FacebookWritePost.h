//
//  FacebookWritePost.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 06/12/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FBConnect.h"

@interface FacebookWritePost : UIViewController <FBSessionDelegate, FBRequestDelegate, FBDialogDelegate, UITextViewDelegate>
{
    Facebook* objFaceBook;
}

@property (nonatomic, strong) Facebook* objFaceBook;

@property (nonatomic, weak) IBOutlet UIScrollView *svwWritePost;
@property (nonatomic, weak) IBOutlet UIImageView *imgvProfilePicture;
@property (nonatomic, weak) IBOutlet UILabel *lblName1;
@property (nonatomic, weak) IBOutlet UILabel *lblFreinds;
@property (nonatomic, weak) IBOutlet UILabel *lblName2;
@property (nonatomic, weak) IBOutlet UITextView *txtMessage;
@property (nonatomic, weak) IBOutlet UIButton *btnPost;

@property (nonatomic, weak) IBOutlet UIView *vwLoading;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *avLoading;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *avLoadingPP;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)writePost:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@end
