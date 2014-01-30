//
//  InternetAccessViewController.m
//  mgx2013
//
//  Created by Amit Karande on 16/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "InternetAccessViewController.h"
#import "Functions.h"
#import "Constants.h"
#import "DeviceManager.h"


@interface InternetAccessViewController ()
@end

@implementation InternetAccessViewController

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
    
    [Analytics AddAnalyticsForScreen:strSCREEN_INTERNET_ACCESS];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray * arrInternetAccess = [defaults objectForKey:@"InternetAccess"];
    NSLog(@"arr %@",arrInternetAccess);
    // NSLog(@"internet data %@",[APP.def objectForKey:@"InternetAccess"]);
    
    
    
    //NSLog(@"def%@",[APP.def objectForKey:@"InternetAccess"]);
    
    //    NSLog(@"internet access %@",APP.arrInternetAccessData);
    //    NSLog(@"***************************");
    //
    dictData1 =  [arrInternetAccess objectAtIndex:0];
    NSLog(@"dict data %@",dictData1);
    
    dictData2 =  [arrInternetAccess objectAtIndex:1];
    NSLog(@"dict data %@",dictData2);
    
    dictData3 =  [arrInternetAccess objectAtIndex:2];
    NSLog(@"dict data %@",dictData3);
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,90, self.view.frame.size.width, self.view.frame.size.height)];
    
    int x = 0;
    
    //int y = 0;
    
    UILabel * lblTittle;
    UILabel * lblSubTittle;
    UILabel * lblDesc;
    UIView * wifiView;
    UIView * mailView;
    UIView * add1View;
    UIView * venue1View;
    UIView * phone1View;
    UIView * add2View;
    UIView * venue2View;
    UIView * phone2View;
    
    for (int i = 0; i < [arrInternetAccess count]; i++)
    {
        if (i == 0) {
            dictData = dictData1;
        }else if (i == 1){
            dictData = dictData2;
        }else{
            dictData = dictData3;
        }
        
        UIView * v=[[UIView alloc]initWithFrame:CGRectMake(0+x, 10, 320, 2000)];
        [self.view addSubview:v];
        v.backgroundColor=[UIColor clearColor];
        
        //Title
        
        
        lblTittle=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 30)];
        lblTittle.text=[dictData objectForKey:@"Title"];
        //[lblTittle sizeToFit];
        /*NSString *theText = lblTittle.text;
         CGFloat width = lblTittle.frame.size.width ;
         CGSize labelTextSize = [theText sizeWithFont:lblTittle.font constrainedToSize:CGSize(width,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
         CGFloat myLabelHeight = labelTextSize.height;*/
        lblTittle.textColor = [UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0];
        //lblTittle.backgroundColor = [UIColor blackColor];
        lblTittle.lineBreakMode = NSLineBreakByWordWrapping;
        lblTittle.numberOfLines = 0;
        
        
        //SubTitle
        
        lblSubTittle=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 300, 200)];
        lblSubTittle.text=[dictData objectForKey:@"SubTitle"];
        //[lblSubTittle sizeToFit];
        //lblSubTittle.backgroundColor = [UIColor redColor];
        lblSubTittle.lineBreakMode = NSLineBreakByWordWrapping;
        lblSubTittle.numberOfLines = 0;
        
        
        
        //Desc
        
        lblDesc=[[UILabel alloc]initWithFrame:CGRectMake(10, 260, 300, 500)];
        //[lblDesc sizeToFit];
        lblDesc.text=[dictData objectForKey:@"InternetAccessDesc"];
        //lblDesc.backgroundColor = [UIColor blueColor];
        lblDesc.lineBreakMode = NSLineBreakByWordWrapping;
        lblDesc.numberOfLines = 0;
        /*
         
         //wifi
         wifiView=[[UIView alloc]initWithFrame:CGRectMake(10, 130, 300, 160)];
         
         UIImageView * wifiImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 50, 130)];
         wifiImgView.image=[UIImage imageNamed:@"ExpoMap.png"];
         wifiView.backgroundColor = [UIColor redColor];
         
         
         UILabel * lblWifiConnection = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 150, 30)];
         lblWifiConnection.text = [dictData objectForKey:@"WifiConnection"];
         
         
         UILabel * lblWifiUserName =[[UILabel alloc]initWithFrame:CGRectMake(100, 80,150, 30)];
         lblWifiUserName.text = [dictData objectForKey:@"WifiUserName""];
         
         UILabel * lblWifiPassword =[[UILabel alloc]initWithFrame:CGRectMake(100, 120,150, 30)];
         lblWifiPassword.text = [dictData objectForKey:@"WifiPassword"];
         
         
         [wifiView addSubview:wifiImgView];
         [wifiView addSubview:lblWifiConnection];
         [wifiView addSubview:lblWifiUserName];
         [wifiView addSubview:lblWifiPassword];
         
         
         //mail
         mailView=[[UIView alloc]initWithFrame:CGRectMake(10, 310, 300, 100)];
         
         UIImageView * mailImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 50, 100)];
         mailImgView.image=[UIImage imageNamed:@"ExpoMap.png"];
         
         mailView.backgroundColor = [UIColor blackColor];
         
         UILabel * lblMailAsk = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 150, 30)];
         lblMailAsk.text = [dictData objectForKey:@"ConvergenceAsk"];
         
         
         UILabel * lblMailAskUrl = [[UILabel alloc]initWithFrame:CGRectMake(100, 80,150, 30)];
         lblMailAskUrl.text =[dictData objectForKey:@"ConvergenceAskURL"];
         
         UIButton * BtnMail = [[UIButton alloc]initWithFrame:CGRectMake(10, 280, mailView.frame.size.width, mailView.frame.size.height)];
         [BtnMail addTarget:self action:@selector(mailclicked:) forControlEvents:UIControlEventTouchUpInside];
         BtnMail.tag=1;
         
         
         [mailView addSubview:mailImgView];
         [mailView addSubview:lblMailAsk];
         [mailView addSubview:lblMailAskUrl];
         [mailView addSubview:BtnMail];
         
         
         //Add1
         
         add1View=[[UIView alloc]initWithFrame:CGRectMake(10, 430, 300, 100)];
         add1View.backgroundColor = [UIColor blueColor];
         UIImageView * add1ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 50, 100)];
         add1ImgView.image=[UIImage imageNamed:@"ExpoMap.png"];
         
         
         UILabel * lblAdd1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 150, 30)];
         lblAdd1.text = [dictData objectForKey:@"Address1"];
         
         UIButton * BtnAdd1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, add1View.frame.size.width, add1View.frame.size.height)];
         [BtnAdd1 addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];
         BtnAdd1.tag=2;
         
         [add1View addSubview:add1ImgView];
         [add1View addSubview:lblAdd1];
         [add1View addSubview:BtnAdd1];
         
         
         //Venue1
         
         venue1View=[[UIView alloc]initWithFrame:CGRectMake(10, 550, 300, 100)];
         venue1View.backgroundColor = [UIColor blackColor];
         UIImageView * venue1ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 50, 100)];
         venue1ImgView.image=[UIImage imageNamed:@"ExpoMap.png"];
         
         
         UILabel * lblvenue1url = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 150, 30)];
         lblvenue1url.text = [dictData objectForKey:@"VenueURL1"];
         
         UIButton * BtnVenue1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, venue1View.frame.size.width, venue1View.frame.size.height)];
         [BtnVenue1 addTarget:self action:@selector(venueclicked:) forControlEvents:UIControlEventTouchUpInside];
         BtnVenue1.tag=3;
         
         [venue1View addSubview:venue1ImgView];
         [venue1View addSubview:lblvenue1url];
         [venue1View addSubview:BtnVenue1];
         
         
         //Phone1
         
         phone1View=[[UIView alloc]initWithFrame:CGRectMake(10, 700, 300, 100)];
         phone1View.backgroundColor = [UIColor redColor];
         UIImageView * phone1ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 50, 100)];
         phone1ImgView.image=[UIImage imageNamed:@"ExpoMap.png"];
         
         
         UILabel * lblphone1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 150, 30)];
         lblphone1.text = [dictData objectForKey:@"Phone1"];;
         
         UILabel * lblphone1Hr = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 150, 30)];
         lblphone1Hr.text = [dictData objectForKey:@"Phone1Hour"];
         
         UIButton * BtnPhone1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, phone1View.frame.size.width, phone1View.frame.size.height)];
         [BtnPhone1 addTarget:self action:@selector(phoneClicked:) forControlEvents:UIControlEventTouchUpInside];
         BtnPhone1.tag=4;
         
         [phone1View addSubview:phone1ImgView];
         [phone1View addSubview:lblphone1];
         [phone1View addSubview:lblphone1Hr];
         [phone1View addSubview:BtnPhone1];
         
         
         //Add2
         
         add2View=[[UIView alloc]initWithFrame:CGRectMake(10, 850, 300, 100)];
         add2View.backgroundColor = [UIColor blueColor];
         UIImageView * add2ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 50, 100)];
         add1ImgView.image=[UIImage imageNamed:@"ExpoMap.png"];
         
         
         UILabel * lblAdd2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 150, 30)];
         lblAdd2.text = [dictData objectForKey:@"Address2"];
         
         UIButton * BtnAdd2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, add2View.frame.size.width, add2View.frame.size.height)];
         [BtnAdd2 addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];
         BtnAdd2.tag=2;
         
         [add2View addSubview:add2ImgView];
         [add2View addSubview:lblAdd2];
         [add2View addSubview:BtnAdd2];
         
         
         //Venue2
         
         venue2View=[[UIView alloc]initWithFrame:CGRectMake(10, 1000, 300, 100)];
         venue2View.backgroundColor = [UIColor blackColor];
         UIImageView * venue2ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 50, 100)];
         venue2ImgView.image=[UIImage imageNamed:@"ExpoMap.png"];
         
         
         UILabel * lblvenue2url = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 150, 30)];
         lblvenue2url.text = [dictData objectForKey:@"VenueURL2"];
         
         UIButton * BtnVenue2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, venue2View.frame.size.width, venue2View.frame.size.height)];
         [BtnVenue2 addTarget:self action:@selector(venueclicked:) forControlEvents:UIControlEventTouchUpInside];
         BtnVenue1.tag=3;
         
         [venue2View addSubview:venue2ImgView];
         [venue2View addSubview:lblvenue2url];
         [venue2View addSubview:BtnVenue2];
         
         
         //Phone2
         
         phone2View=[[UIView alloc]initWithFrame:CGRectMake(10, 1150, 300, 100)];
         phone2View.backgroundColor = [UIColor redColor];
         UIImageView * phone2ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 50, 100)];
         phone2ImgView.image=[UIImage imageNamed:@"ExpoMap.png"];
         
         
         UILabel * lblphone2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 150, 30)];
         lblphone2.text = [dictData objectForKey:@"Phone2"];
         
         UILabel * lblphone2Hr = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 150, 30)];
         lblphone2Hr.text = [dictData objectForKey:@"Phone2Hour"];
         
         UIButton * BtnPhone2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, phone2View.frame.size.width, phone1View.frame.size.height)];
         [BtnPhone2 addTarget:self action:@selector(phoneClicked:) forControlEvents:UIControlEventTouchUpInside];
         BtnPhone2.tag=4;
         
         [phone2View addSubview:phone2ImgView];
         [phone2View addSubview:lblphone2];
         [phone2View addSubview:lblphone2Hr];
         [phone2View addSubview:BtnPhone2];
         
         */
        
        ///add subviews
        [v addSubview:lblTittle];
        [v addSubview:lblSubTittle];
        [v addSubview:lblDesc];
        /*     [v addSubview:wifiView];
         [v addSubview:mailView];
         [v addSubview:add1View];
         [v addSubview:venue1View];
         [v addSubview:phone1View];
         [v addSubview:add2View];
         [v addSubview:venue2View];
         [v addSubview:phone2View];*/
        
        [scrollView addSubview:v];
        x=x+320;
    }
    scrollView.pagingEnabled=YES;
    
    //  scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height*2);
    
    scrollView.contentSize=CGSizeMake(x, 2000);
    
    
    
    [self.view addSubview:scrollView];
    
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if([DeviceManager IsiPad] == YES)
    {
        return UIInterfaceOrientationMaskAll;
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

- (IBAction)btnBackClicked:(id)sender
{
    //NSLog(@"%f",[svwInternetAccess contentOffset].x);
    if([self.svwInternetAccess contentOffset].x == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if ([DeviceManager IsiPhone])
        {
            [self.svwInternetAccess setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}
- (IBAction)addClicked:(id)sender
{
    [Functions MakePhoneCall:@"902 233 200"];
}
- (IBAction)phoneClicked:(id)sender
{
    [Functions MakePhoneCall:@"902 233 200"];
}


//- (IBAction)MakePhoneCall:(id)sender
//{
//    [Functions MakePhoneCall:@"902 233 200"];
//}
@end
