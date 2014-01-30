//
//  HappeningNowViewController.m
//  mgx2013
//
//  Created by Amit Karande on 05/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "PhotoDetailViewController.h"
#import "DeviceManager.h"
#import "User.h"
#import "NSString+Custom.h"
#import "Functions.h"
#import "NSURLConnection+Tag.h"
#import "SessionNoteViewController.h"
#import "Constants.h"
#import "FBJSON.h"
#import "NSData+Base64.h"
#import "CustomCollectionViewCell.h"

@interface PhotoGalleryViewController()
{
    @private
    id objSender;
}
@end

@implementation PhotoGalleryViewController
@synthesize objConnection, objData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[self btnBrowse] layer] setBorderWidth:2.0f];
    [[[self btnBrowse] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnBrowse] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnBrowse] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnCapture] layer] setBorderWidth:2.0f];
    [[[self btnCapture] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnCapture] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnCapture] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnUpload] layer] setBorderWidth:2.0f];
    [[[self btnUpload] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnUpload] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnUpload] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnCancel] layer] setBorderWidth:2.0f];
    [[[self btnCancel] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnCancel] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnCancel] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.dictData == nil)
    {
        self.dictData = [[NSMutableDictionary alloc] init];
    }
    
    [self refresh];
    [self getMyUploads];
    
    //[UIView addTouchEffect:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
     objSender = nil;
}

-(void)viewDidLayoutSubviews{
    
    [self.scrollView setContentSize:CGSizeMake(640, self.scrollView.frame.size.height)];
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

- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (IBAction)btnBackClicked:(id)sender
{
    //NSLog(@"%f",[scrollView contentOffset].x);
    if([self.scrollView contentOffset].x == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if ([DeviceManager IsiPhone])
        {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
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

- (void)refresh
{
    self.textFieldTitle.text = @"";
    self.textViewDescription.text = @"";
    self.textFieldBrowse.text =@"";
    self.dictData = nil;
    self.dictData = [[NSMutableDictionary alloc] init];
    [self.activityView setHidden:YES];
}


- (IBAction)upload:(id)sender
{
    /////////////////////////
    // start Validating
    /////////////////////////
    
    BOOL isValid = YES;
    //NSMutableString *msg = [NSMutableString stringWithFormat:@"Please"];
    NSString *msg= @"";
    
    self.textFieldTitle.layer.borderColor=[[UIColor clearColor]CGColor];
    
    if(self.textFieldTitle.text.length == 0 && isValid == YES)
    {
        isValid = NO;
        //[msg appendFormat:@" enter title"];
        msg = @"title cannot be blank.";
        //self.textFieldTitle.layer.masksToBounds=YES;
        //self.textFieldTitle.layer.borderColor=[[UIColor redColor]CGColor];
        //self.textFieldTitle.layer.borderWidth= 1.0f;
    }
    
    self.textFieldBrowse.layer.borderColor=[[UIColor clearColor]CGColor];
    
    if(![self.dictData objectForKey:@"photo"] && isValid == YES)
    {
        if (isValid == NO)
        {
            //[msg appendFormat:@" and"];
        }
        
        isValid = NO;
        //[msg appendFormat:@" add photo"];
        msg = @"No image is selected for upload.";
        //self.textFieldBrowse.layer.masksToBounds=YES;
        //self.textFieldBrowse.layer.borderColor=[[UIColor redColor]CGColor];
        //self.textFieldBrowse.layer.borderWidth= 1.0f;
    }
    
    if(isValid == NO)
    {
        //[msg appendFormat:@" to upload."];
        [self showAlert:@"" withMessage:msg withButton:@"OK" withIcon:nil];
        return;
    }
    
    [self.activityView setHidden:NO];
    
    //simulate async service call by firing timer so activityview will start
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(beginUploadThumb) userInfo:nil repeats:NO];
}

- (void) beginUpload
{
    UIImage  *photoImg = [self.dictData objectForKey:@"photo"];
    [self sendRequest:photoImg withSrv:strAPI_PHOTOS_UPLOAD withOper:OPER_PHOTOS_UPLOAD];
}

- (void) beginUploadThumb
{
    UIImage  *photoImg = [self.dictData objectForKey:@"thumb"];
    [self sendRequest:photoImg withSrv:strAPI_PHOTOS_UPLOAD_THUMB withOper:OPER_PHOTOS_UPLOAD_THUMB];
}

- (IBAction)cancel:(id)sender
{
    [self refresh];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Textfield and Textview Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    [[self lblViewDescriptionPlaceHolder] setHidden:YES];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if(self.textViewDescription.text.length == 0)
    {
        [[self lblViewDescriptionPlaceHolder] setHidden:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound )
    {
        return YES;
    }
    
    [txtView resignFirstResponder];
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Imagepicker Buttons (capture / browse)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (IBAction)getCameraPicture:(id)sender {
    
    // Check to see if sourcetype is available otherwise app will crash in simulator
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
            picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
    
            [self presentViewController:picker
                       animated:YES
                     completion:nil];
    }

}

- (IBAction)selectExistingPicture:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    [self presentViewController:picker
                       animated:YES
                     completion:nil];
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Imagepicker Callbacks
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        
        NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        
        if (url) {
            
            /////////////////////////
            // from library
            /////////////////////////
            
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                [self processAsset:myasset];
                
            };
            
            
            ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
                
                
                if ([[myerror localizedDescription] isEqualToString:@"User denied access"] ) {
                    
                    NSString *errorText = @"You've already denied this app access to location information contained in your photos. This prevents you from accessing your photo library, which prevents you from attaching any photos to your observations. To enable the use of photos, please close this app, open the Settings app on your device, tap General, tap Reset, then tap \"Reset Location Warnings.\" Then restart your device. The next time you open Deer Camp, when asked for permission to access your photo library, please select \"OK.\"";
                    
                    [self showAlert:@"Warning" withMessage:errorText withButton:@"OK" withIcon:nil];
                    
                } else {
                    
                    NSLog(@"cant get image - %@", [myerror localizedDescription]);
                    [self showAlert:@"Image Error" withMessage:@"Could not retrieve image." withButton:@"OK" withIcon:nil];
                    
                }
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            };
            
            
            ALAssetsLibrary *assetsLib = [[ALAssetsLibrary alloc] init];
            [assetsLib assetForURL:url resultBlock:resultblock failureBlock:failureblock];
            
        } else {
            
            /////////////////////////
            // from camera
            /////////////////////////
            
            ALAssetsLibraryWriteImageCompletionBlock compBlock = ^(NSURL *assetURL, NSError *error) {
                
                // camera image saved
                if (error != nil || assetURL == nil) {
                    
                    [self showAlert:@"Image Error" withMessage:@"Could not retrieve image." withButton:@"OK" withIcon:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }
                
                else {
                    
                    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [self processAsset:myasset];
                        
                    };
                    
                    
                    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
                        NSLog(@"cant get image - %@", [myerror localizedDescription]);
                        [self showAlert:@"Image Error" withMessage:@"Could not retrieve image." withButton:@"OK" withIcon:nil];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    };
                    
                    ALAssetsLibrary *assetsLib = [[ALAssetsLibrary alloc] init];
                    [assetsLib assetForURL:assetURL resultBlock:resultblock failureBlock:failureblock];
                    
                }
            };
            
            
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
            if (!image) {
                
                [self showAlert:@"Image Error" withMessage:@"Could not retrieve image." withButton:@"OK" withIcon:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
                
                return;
            }
            
            // write camera image to library
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            NSMutableDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
            
            [self setImageOrientarion:image.imageOrientation forDictionary:metadata];
            
            [library writeImageToSavedPhotosAlbum:[image CGImage] metadata:metadata completionBlock:compBlock];
          
            
        }
    }
}


/* The intended display orientation of the image. If present, the value
 * of this key is a CFNumberRef with the same value as defined by the
 * TIFF and Exif specifications.  That is:
 *   1  =  0th row is at the top, and 0th column is on the left.
 *   2  =  0th row is at the top, and 0th column is on the right.
 *   3  =  0th row is at the bottom, and 0th column is on the right.
 *   4  =  0th row is at the bottom, and 0th column is on the left.
 *   5  =  0th row is on the left, and 0th column is the top.
 *   6  =  0th row is on the right, and 0th column is the top.
 *   7  =  0th row is on the right, and 0th column is the bottom.
 *   8  =  0th row is on the left, and 0th column is the bottom.
 * If not present, a value of 1 is assumed. */

// Reference: http://sylvana.net/jpegcrop/exif_orientation.html
- (void)setImageOrientarion:(UIImageOrientation)orientation forDictionary:(NSMutableDictionary*)dict {
    int o = 1;
    switch (orientation) {
        case UIImageOrientationUp:
            o = 1;
            break;
            
        case UIImageOrientationDown:
            o = 3;
            break;
            
        case UIImageOrientationLeft:
            o = 8;
            break;
            
        case UIImageOrientationRight:
            o = 6;
            break;
            
        case UIImageOrientationUpMirrored:
            o = 2;
            break;
            
        case UIImageOrientationDownMirrored:
            o = 4;
            break;
            
        case UIImageOrientationLeftMirrored:
            o = 5;
            break;
            
        case UIImageOrientationRightMirrored:
            o = 7;
            break;
    }
    
    [dict setObject:[NSNumber numberWithInt:o] forKey:(NSString*)kCGImagePropertyOrientation];
}

- (void)processAsset:(ALAsset *)myasset
{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    ALAssetRepresentation *rep = [myasset defaultRepresentation];
    
    CGImageRef ilargeref = [rep fullScreenImage];
    if (ilargeref)
    {
        UIImage *image = [UIImage imageWithCGImage:ilargeref scale:1.0 orientation:[[myasset valueForProperty:@"ALAssetPropertyOrientation"]intValue]];
        
        //CGSize scaleSize = CGSizeMake(600, 600);
        //UIImage *scaleImg = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:scaleSize interpolationQuality:kCGInterpolationHigh];
        
        UIImage *scaleImg = image;
        
        [self.dictData setObject:scaleImg forKey:@"photo"];
        //NSLog(@"%@",[rep filename]);
        NSString *strFileName = [NSString stringWithFormat:@"%d%@",timestamp, [rep filename]];
        //NSLog(@"%@",strFileName);
        [self.dictData setObject:strFileName forKey:@"filename"];
        
        self.textFieldBrowse.text = [NSString stringWithString:[rep filename]];
        
        //CGSize thumbSize = CGSizeMake(60, 60);
        //UIImage *thumbImg = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:thumbSize interpolationQuality:kCGInterpolationHigh];
        
        CGImageRef ithumbref = [myasset thumbnail];
        UIImage *thumbImg = [UIImage imageWithCGImage:ithumbref scale:1.0 orientation:[[myasset valueForProperty:@"ALAssetPropertyOrientation"]intValue]];
        
        [self.dictData setObject:thumbImg forKey:@"thumb"];

        //NSLog(@"%@",[[rep filename] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",[[rep filename] pathExtension]] withString:[NSString stringWithFormat:@"_T.%@",[[rep filename] pathExtension]]]);
        //NSString *strThumbFileName = [[rep filename] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",[[rep filename] pathExtension]] withString:[NSString stringWithFormat:@"_T.%@",[[rep filename] pathExtension]]];
        //strThumbFileName = [NSString stringWithFormat:@"%d%@",timestamp, strThumbFileName];
        //[self.dictData setObject:strThumbFileName forKey:@"thumbfilename"];
        [self.dictData setObject:strFileName forKey:@"thumbfilename"];
    }
    else
    {
        [self showAlert:@"Image Error" withMessage:@"Could not process image." withButton:@"OK" withIcon:nil];
    }
}

- (NSString *)urlencode:(NSString*)str
{
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) str,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));
    return escapedString;
}

- (void)sendRequest:(UIImage *)imageToPost withSrv:(NSString *)srvStr withOper:(int)operation
{
    //override API with old one
    NSString *file = @"";
    if (OPER_PHOTOS_UPLOAD == operation)
    {
        file = [self.dictData objectForKey:@"filename"];
        srvStr = strAPI_OLD_PHOTOS_UPLOAD;
    }
    else
    {
        file = [self.dictData objectForKey:@"thumbfilename"];
        srvStr = strAPI_OLD_PHOTOS_UPLOAD_THUMB;
    }
    
    User *objUser = [User GetInstance];
    
    NSString *title         = [self urlencode:self.textFieldTitle.text];
    NSString *desc          = [self urlencode:self.textViewDescription.text];
    //file          = [self.dictData objectForKey:@"filename"];
    //int timestamp           = [[NSDate date] timeIntervalSince1970];
    //NSString *filename      = [NSString stringWithFormat:@"%@%d%@",[objUser GetID] ,timestamp, file];
    NSString *filename      = [NSString stringWithFormat:@"%@%@",[objUser GetID], file];
    NSString *conferenceID  = @"1";
    NSString *clientID      = @"1";
    NSArray  *tags          = [title componentsSeparatedByString:@" "];
    NSString *tagStr        = [tags componentsJoinedByString:@","];
    NSString *userid        = [objUser GetAccountEmail];
    NSString *device        = [DeviceManager GetDeviceType];
    NSString *params        = [NSString stringWithFormat:@"ClientID=%@&ConferenceID=%@&Title=%@&PhotoDescription=%@&SearchTags=%@&User=%@&Device=%@&img=%@", clientID, conferenceID, title, desc, tagStr, userid, device, filename];
    
    NSData *imageData = UIImagePNGRepresentation(imageToPost);
    NSString *postLength = [NSString stringWithFormat:@"%d", [imageData length]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    NSString *strURL = [NSString stringWithFormat:@"%@?%@", srvStr ,params];
    
    [request setURL:[NSURL URLWithString:strURL]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:imageData];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES tag:operation];
   
    
    /* NEW API
     
    User *objUser = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:strUSER_DEFAULT_KEY_USER_INFO]];
    
    NSString *title         = self.textFieldTitle.text;
    NSString *desc          = self.textViewDescription.text;
    NSString *file          = [self.dictData objectForKey:@"filename"];
    int timestamp           = [[NSDate date] timeIntervalSince1970];;
    NSString *filename      = [NSString stringWithFormat:@"%@%d%@",[objUser GetID] ,timestamp, file];
    NSArray  *tags          = [title componentsSeparatedByString:@" "];
    NSString *tagStr        = [tags componentsJoinedByString:@","];
     
    NSData *imageData = UIImagePNGRepresentation(imageToPost);
    NSString *base64EncodedString = [imageData base64EncodedString];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    [dictData setObject:filename forKey:@"FileName"];
    [dictData setObject:base64EncodedString forKey:@"Image"];
    [dictData setObject:title forKey:@"Title"];
    [dictData setObject:desc forKey:@"PhotoDescription"];
    [dictData setObject:tagStr forKey:@"SearchTags"];
    
    NSString* strData = [dictData JSONRepresentation];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [strData length]];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:srvStr];
    NSURL *URL = [NSURL URLWithString:strURL];
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [objRequest setHTTPBody: [strData dataUsingEncoding:NSUTF8StringEncoding]];
   
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:operation];
    */
    
}



#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@",error);
    objSender = nil;
    [self.activityView setHidden:YES];
    
    NSInteger intTag = (int)[connection getTag];
    
    switch (intTag)
    {
        case OPER_PHOTOS_UPLOAD:
        {
            
            [self showAlert:@"Upload Error" withMessage:@"There was a problem uploading your photo. Please try again later." withButton:@"OK" withIcon:nil];
                        
        }
            break;
            
        default:
            break;
    }
    
    [[self vwLoading] setHidden:YES];
    [[self avLoading] stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"didReceiveResponse: %@",response);
    objData = [[NSMutableData alloc] init];
    //[self.activityView setHidden:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [objData appendData:data];
    //[self.activityView setHidden:YES];
}

- (void)getMyUploads
{
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    User *objUser = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:strUSER_DEFAULT_KEY_USER_INFO]];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_PHOTOS_GET_UPLOADS];
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

    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_PHOTOS_GET_UPLOADS];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //idDetail
    PhotoDetailViewController *vcPhotoDetailViewController;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcPhotoDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"idDetail"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcPhotoDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"idDetail"];
    }
    
    vcPhotoDetailViewController.photoList = [self.uploadList mutableCopy];
    vcPhotoDetailViewController.blnCalledFromMyUploads = YES;
    [[self navigationController] pushViewController:vcPhotoDetailViewController animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.uploadList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell.avLoading  startAnimating];
    
    NSString *strImage = [[self.uploadList objectAtIndex:indexPath.row] objectForKey:@"PhotoURL"];
    
    //if([strImage rangeOfString:@"_T."].location == NSNotFound)
    //{
    //}
    //else
    //{
    //    NSMutableArray *arrImageComponents = [[strImage componentsSeparatedByString:@"_T."] mutableCopy];
    //    [arrImageComponents replaceObjectAtIndex:[arrImageComponents count] - 1 withObject:[[arrImageComponents objectAtIndex:[arrImageComponents count] - 1] uppercaseString]];
    //    //strImage = [strImage stringByReplacingOccurrencesOfString:@"_T." withString:@"."];
    //    strImage = [arrImageComponents componentsJoinedByString:@"."];
    //}
    
    NSURL *imgURL = [NSURL URLWithString:strImage];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
    NSData *data,
    NSError *error)
    {
        if (!error)
        {
            /*
            cell.articleImage.image = [UIImage imageWithData:data];
            NSString *cellText = [[self.uploadList objectAtIndex:indexPath.row] objectForKey:@"Title"];
            NSArray *comments = [[self.uploadList objectAtIndex:indexPath.row] objectForKey:@"PhotoComments"];

            if (comments.count > 0)
            {
                NSDictionary *obj = [comments objectAtIndex:comments.count-1];
                cellText = [NSString stringWithFormat:@"%@\n%@",cellText,[obj objectForKey:@"CommentText"]];
            }
            
            cell.TxtDesc.text = cellText;
            */
            
            cell.articleImage.image = [UIImage imageWithData:data];
            /*NSDictionary *obj = [self.uploadList objectAtIndex:indexPath.row];
            NSString *strTitle = [obj objectForKey:@"Title"];
            if([NSString IsEmpty:strTitle shouldCleanWhiteSpace:YES] == YES)
            {
                strTitle = [obj objectForKey:@"title"];
            }
            NSString *strEmail = [Functions ReplaceNUllWithBlank:[obj objectForKey:@"UploadedBy"]];
            //strComments = (strComments && ![strComments isKindOfClass:[NSNull class]]) ? strComments: @"";
            cell.TxtDesc.text = [NSString stringWithFormat:@"%@\n%@",strTitle,strEmail];
            */
            [cell.avLoading  startAnimating];
        }
        else
        {
            NSLog(@"error %@",error);
        }
    }];
    
    NSDictionary *obj = [self.uploadList objectAtIndex:indexPath.row];
    NSString *strTitle = [obj objectForKey:@"Title"];
    if([NSString IsEmpty:strTitle shouldCleanWhiteSpace:YES] == YES)
    {
        strTitle = [obj objectForKey:@"title"];
    }
    NSString *strEmail = [Functions ReplaceNUllWithBlank:[obj objectForKey:@"UploadedBy"]];
    //strComments = (strComments && ![strComments isKindOfClass:[NSNull class]]) ? strComments: @"";
    cell.TxtDesc.text = [NSString stringWithFormat:@"%@\n%@",strTitle,strEmail];
    
    [[self vwLoading] setHidden:YES];
    [[self avLoading] startAnimating];
    
    return cell;
}

/*
- (CGRect)collectionViewContentSize
{
    double itemCount = [self.uploadList count];
    
    if([DeviceManager IsiPad] == YES)
    {
        double totalHeight = ceil(itemCount/iPad_NO_of_Cols)*(iPad_Item_Height) +10;
        
        return CGRectMake(self.photoCollectionView.frame.origin.x, self.photoCollectionView.frame.origin.y, self.photoCollectionView.frame.size.width, totalHeight);
    }
    else
    {
        double totalHeight = ceil(itemCount/iPhone_NO_of_Cols)*(iPhone_Item_Height) +10;
        return CGRectMake(self.photoCollectionView.frame.origin.x, self.photoCollectionView.frame.origin.y, self.photoCollectionView.frame.size.width, totalHeight);
        
    }
}
*/

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSInteger intTag = (int)[connection getTag];
    //NSLog(@"Connection Tag: %d",intTag);
    
    NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@",strData);
    
    //[self.activityView setHidden:YES];
    
    switch (intTag)
    {
        case OPER_PHOTOS_UPLOAD:
            {
                [self.activityView setHidden:YES];
                
                if ([strData isEqualToString:@"Success"])
                {
                    [self showAlert:@"" withMessage:@"Photo uploaded successfully. It will be visible in photo gallery after approval." withButton:@"OK" withIcon:nil];
                    [self refresh];
                    
                    objSender = nil;
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            break;
        case OPER_PHOTOS_UPLOAD_THUMB:
            {
                if ([strData isEqualToString:@"Success"])
                {
                    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(beginUpload) userInfo:nil repeats:NO];

                    //[self showAlert:@"" withMessage:@"Your photo has been uploaded." withButton:@"OK" withIcon:nil];
                    //[self refresh];
                    
                    //objSender = nil;
                    
                    //[self.navigationController popViewControllerAnimated:YES];
                }
            }
            break;
        case OPER_PHOTOS_GET_UPLOADS:
            {
                [self.activityView setHidden:YES];
                
                self.uploadList = [[NSArray alloc] init];
                
                NSError *jsonError;
                self.uploadList = [NSJSONSerialization JSONObjectWithData:objData options:0 error:&jsonError];
                
                if(jsonError != nil)
                {
                    NSLog(@"JSON Error: %@", jsonError);
                    return;
                }
                
                [self.photoCollectionView reloadData];
            }
            break;
        default:
            break;
    }
    
}
#pragma mark -
@end
