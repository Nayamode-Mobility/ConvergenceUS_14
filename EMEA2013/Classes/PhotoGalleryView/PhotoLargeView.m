//
//  PhotoLargeView.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 28/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "PhotoLargeView.h"
#import "DeviceManager.h"

@interface PhotoLargeView ()

@end

@implementation PhotoLargeView

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
    
    [[self avLoading] startAnimating];
    
    NSString *strImage = ([[self curPict] objectForKey:@"PhotoURL"]) ? [[self curPict] objectForKey:@"PhotoURL"] : [[self curPict] objectForKey:@"PhotoUrl"];
    if (!strImage || [strImage isKindOfClass:[NSNull class]] ) return;
    
    if([strImage rangeOfString:@"_T."].location == NSNotFound)
    {
    }
    else
    {
        NSMutableArray *arrImageComponents = [[strImage componentsSeparatedByString:@"_T."] mutableCopy];
        [arrImageComponents replaceObjectAtIndex:[arrImageComponents count] - 1 withObject:[[arrImageComponents objectAtIndex:[arrImageComponents count] - 1] uppercaseString]];
        //strImage = [strImage stringByReplacingOccurrencesOfString:@"_T." withString:@"."];
        strImage = [arrImageComponents componentsJoinedByString:@"."];
    }
    
    NSURL *urlImage = [NSURL URLWithString:strImage];
    
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:urlImage];
    
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
    NSData *data,
    NSError *error)
    {
        if (!error)
        {
            UIImage *imgLargeView = [UIImage imageWithData:data];
            //[self.imgvLargeView setImage:[UIImage imageWithData:data]];
            [self.imgvLargeView setImage:imgLargeView];
            [self.imgvLargeView sizeToFit];
            
            self.svwLargeView.contentSize = imgLargeView.size;
            self.svwLargeView.delegate = self;
            self.svwLargeView.minimumZoomScale = 1.0;
            self.svwLargeView.maximumZoomScale = 100.0;
            
            [[self avLoading] stopAnimating];
        }
        else
        {
            [[self avLoading] stopAnimating];
            NSLog(@"error %@",error);
        }
        
        [self.imgvLargeView setAlpha:0.0];
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        [self.imgvLargeView setAlpha:1.0];
        [UIView commitAnimations];
    }];
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
@end
