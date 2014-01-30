//
//  HappeningNowViewController.h
//  mgx2013
//
//  Created by Amit Karande on 05/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Resize.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import <Foundation/Foundation.h>

@interface PhotoGalleryViewController :UIViewController< UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
}

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextView *textViewDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblViewDescriptionPlaceHolder;
@property (strong, nonatomic) IBOutlet UITextField *textFieldTitle;
@property (strong, nonatomic) IBOutlet UITextField *textFieldBrowse;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (strong, nonatomic) NSArray *uploadList;

@property (strong, nonatomic) IBOutlet UIButton *btnBrowse;
@property (strong, nonatomic) IBOutlet UIButton *btnCapture;
@property (strong, nonatomic) IBOutlet UIButton *btnUpload;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)upload:(id)sender;
- (void) beginUpload;
- (void) beginUploadThumb;
- (void)setImageOrientarion:(UIImageOrientation)orientation forDictionary:(NSMutableDictionary*)dict;
- (IBAction)cancel:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)getCameraPicture:(id)sender;
- (IBAction)selectExistingPicture:(id)sender;
- (NSString *)urlencode:(NSString*)str;
- (void)getMyUploads;

- (void)processAsset:(ALAsset *)myasset;
- (void)sendRequest:(UIImage *)imageToPost withSrv:(NSString *)srvStr withOper:(int)operation;
- (void)showAlert:(NSString*)titleMsg withMessage:(NSString*)alertMsg withButton:(NSString*)btnMsg withIcon:(NSString*)imagePath;
- (void)refresh;

@property (nonatomic, weak) IBOutlet UIView *vwLoading;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *avLoading;
@end
