 //
//  LargeView.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 04/12/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "LargeView.h"
#import "DeviceManager.h"

@interface LargeView ()

@end

@implementation LargeView

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
    
    UIImage* imgRotated = [self rotateImageAppropriately:[self imgSource]];
    
    //[self.imgvLargeView setImage:[self imgSource]];
    [self.imgvLargeView setImage:imgRotated];
    //[self.imgvLargeView sizeToFit];
    
    self.svwLargeView.contentSize = [[self imgSource] size];
    //self.svwLargeView.contentSize = [imgRotated size];
    
    self.svwLargeView.delegate = self;
    self.svwLargeView.minimumZoomScale = 1.0;
    self.svwLargeView.maximumZoomScale = 100.0;

    [self.imgvLargeView setAlpha:0.0];
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [self.imgvLargeView setAlpha:1.0];
    [UIView commitAnimations];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.svwLargeView.bounds), CGRectGetMidY(self.svwLargeView.bounds));
    [self view:self.imgvLargeView setCenter:centerPoint];
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

- (IBAction)btnBackClicked:(id)sender
{
    //NSLog(@"%f",[svwLargeView contentOffset].x);
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgvLargeView;
}

- (void)view:(UIView*)view setCenter:(CGPoint)centerPoint
{
    CGRect vf = view.frame;
    CGPoint co = self.svwLargeView.contentOffset;
    
    CGFloat x = centerPoint.x - vf.size.width/2.0;
    CGFloat y = centerPoint.y - vf.size.height/2.0;
    
    if(x < 0)
    {
        co.x = -x;
        vf.origin.x = 0.0;
    }
    else
    {
        vf.origin.x = x;
    }
    if(y < 0)
    {
        co.y = -y;
        vf.origin.y = 0.0;
    }
    else
    {
        vf.origin.y = y;
    }
    
    view.frame = vf;
    self.svwLargeView.contentOffset = co;
}

- (void)scrollViewDidZoom:(UIScrollView *)sv
{
    UIView* zoomView = [sv.delegate viewForZoomingInScrollView:sv];
    CGRect zvf = zoomView.frame;
    
    if(zvf.size.width < sv.bounds.size.width)
    {
        zvf.origin.x = (sv.bounds.size.width - zvf.size.width) / 2.0;
    }
    else
    {
        zvf.origin.x = 0.0;
    }
    if(zvf.size.height < sv.bounds.size.height)
    {
        zvf.origin.y = (sv.bounds.size.height - zvf.size.height) / 2.0;
    }
    else
    {
        zvf.origin.y = 0.0;
    }
    
    zoomView.frame = zvf;
}

- (UIImage*)rotateImageAppropriately:(UIImage*)imageToRotate
{
    //This method will properly rotate our image, we need to make sure that
    //We call this method everywhere pretty much...
    
    CGImageRef imageRef = [imageToRotate CGImage];
    UIImage* properlyRotatedImage;
    
    properlyRotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
    
    return properlyRotatedImage;
}

@end
