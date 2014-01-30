
#import "ShuttleInfoViewController.h"
#import "AppDelegate.h"
#import "shuttleInfo.h"




@interface ShuttleInfoViewController ()

@end

@implementation ShuttleInfoViewController
@synthesize backshuttleBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    arrShuttleInfo = [APP.dictShuttleData valueForKey:@"Info"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,backshuttleBtn.frame.origin.y+25, self.view.frame.size.width, self.view.frame.size.height)];
    
    //NSLog(@"%@",[APP.shuttleInfoArrayobj description]);
    
    int x = 0;
    
    int y=0;
    
    UILabel * lblTittle;
    UILabel * lblDescription;
    UILabel * lblBriefdescription;
    UIView * Phone1View;
    UIView * Phone2View;
    UIView * Phone3View;
    UIView * emailView;
    UILabel * Email2;
    UILabel * Email3;
    
    
    for (int i = 0; i < [arrShuttleInfo count]; i++)
    {
        UIView * v=[[UIView alloc]initWithFrame:CGRectMake(0+x, 10, 320, 480)];
        //v.backgroundColor=[UIColor grayColor];
        
        [self.view addSubview:v];
        
        
        shuttleInfo *objShuttleInfo = [[shuttleInfo alloc]init];
        objShuttleInfo=[arrShuttleInfo objectAtIndex:i];
        
        if(objShuttleInfo.strTitle != (id)[NSNull null])
        {
            lblTittle=[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 50)];
            y=lblTittle.frame.origin.y+lblTittle.frame.size.height+5;
            
            NSLog(@"%d",y);
            
            lblTittle.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).strTitle;
            
            lblTittle.lineBreakMode = NSLineBreakByWordWrapping;
            lblTittle.numberOfLines = 0;
        }
        if(objShuttleInfo.strBriefDescription != (id)[NSNull null])
        {
            lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(10,y, 300, 50)];
            y=lblDescription.frame.origin.y+lblDescription.frame.size.height+5;
            
            lblDescription.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).strBriefDescription;
            
            NSLog(@"%d",y);
            
            
        }
        
        if(objShuttleInfo.strBriefDescription2 != (id)[NSNull null])
        {
            
            lblBriefdescription=[[UILabel alloc]initWithFrame:CGRectMake(10, y, 300, 50)];
            y=lblBriefdescription.frame.origin.y+lblBriefdescription.frame.size.height+5;
            
            NSLog(@"%d",y);
            
            lblBriefdescription.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).strBriefDescription2;
            
        }
        
        /******** Phone 1 ************************/
        if(objShuttleInfo.Phone1 != (id)[NSNull null])
        {
            Phone1View=[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, 80)];
            
            UIImageView * phone1ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 20, 30)];
            phone1ImgView.image=[UIImage imageNamed:@"phone.png"];
            
            
            
            UILabel * lblPhone=[[UILabel alloc]initWithFrame:CGRectMake(50, 15, 150, 30)];
            // lblPhone.text=@"67677878";
            lblPhone.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).Phone1;
            
            
            UILabel * lblPhoneText=[[UILabel alloc]initWithFrame:CGRectMake(50, lblPhone.frame.origin.y+lblPhone.frame.size.height+3,150, 30)];
            lblPhoneText.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).Phone1Text;
            
            // lblPhoneText.text=@"hiirtbt";
            
            UIButton * phone1Btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Phone1View.frame.size.width, Phone1View.frame.size.height)];
            [phone1Btn addTarget:self action:@selector(phone1Clicked:) forControlEvents:UIControlEventTouchUpInside];
            phone1Btn.tag=1;
            
            [Phone1View addSubview:phone1ImgView];
            [Phone1View addSubview:lblPhone];
            [Phone1View addSubview:lblPhoneText];
            [Phone1View addSubview:phone1Btn];
            
            y=Phone1View.frame.origin.y+Phone1View.frame.size.height+5;
            
            NSLog(@"%d",y);
            
        }
        
        /*********** Phone 2 ***********************/
        
        if(objShuttleInfo.Phone2 != (id)[NSNull null])
        {
            
            Phone2View=[[UIView alloc]initWithFrame:CGRectMake(10, y, 300, 80)];
            
            UIImageView * phone2ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 20, 30)];
            phone2ImgView.image=[UIImage imageNamed:@"phone.png"];
            
            UILabel * lblPhone2=[[UILabel alloc]initWithFrame:CGRectMake(50, 15, 150, 30)];
            
            lblPhone2.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).Phone2;
            
            // lblPhone2.text=@"67677878";
            
            UILabel * lblPhoneText2=[[UILabel alloc]initWithFrame:CGRectMake(50, lblPhone2.frame.origin.y+lblPhone2.frame.size.height+3,150, 30)];
            
            lblPhoneText2.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).Phone2Text;
            
            // lblPhoneText2.text=@"hiirtbt";
            
            UIButton * phone2Btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Phone2View.frame.size.width, Phone2View.frame.size.height)];
            [phone2Btn addTarget:self action:@selector(phone1Clicked:) forControlEvents:UIControlEventTouchUpInside];
            phone2Btn.tag=2;
            
            [Phone2View addSubview:phone2ImgView];
            [Phone2View addSubview:lblPhone2];
            [Phone2View addSubview:lblPhoneText2];
            [Phone2View addSubview:phone2Btn];
            
            y=Phone2View.frame.size.height+5;
            
            NSLog(@"%d",y);
            
        }
        
        /*********** Phone 3**************************/
        
        if(objShuttleInfo.Phone3 != (id)[NSNull null])
        {
            
            Phone3View=[[UIView alloc]initWithFrame:CGRectMake(10,y, 300, 80)];
            
            UIImageView * phone3ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 20, 30)];
            phone3ImgView.image=[UIImage imageNamed:@"phone.png"];
            
            UILabel * lblPhone3=[[UILabel alloc]initWithFrame:CGRectMake(50, 15, 150, 30)];
            
            lblPhone3.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).Phone3;
            
            //  lblPhone3.text=@"67677878";
            
            UILabel * lblPhoneText3=[[UILabel alloc]initWithFrame:CGRectMake(50, lblPhone3.frame.origin.y+lblPhone3.frame.size.height+3,150, 30)];
            
            lblPhoneText3.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).Phone3Text;
            
            // lblPhoneText3.text=@"hiirtbt";
            
            UIButton * phone3Btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Phone3View.frame.size.width, Phone3View.frame.size.height)];
            [phone3Btn addTarget:self action:@selector(phone1Clicked:) forControlEvents:UIControlEventTouchUpInside];
            phone3Btn.tag=3;
            
            [Phone3View addSubview:phone3ImgView];
            [Phone3View addSubview:lblPhone3];
            [Phone3View addSubview:lblPhoneText3];
            [Phone3View addSubview:phone3Btn];
            
            y=Phone3View.frame.size.height+5;
            
            NSLog(@"%d",y);
            
        }
        
        /******************* Email View *********************/
        
        if(objShuttleInfo.Email1 != (id)[NSNull null])
        {
            
            emailView=[[UIView alloc]initWithFrame:CGRectMake(10,y, 300, 80)];
            
            UIImageView * emailImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 20, 30)];
            emailImgView.image=[UIImage imageNamed:@"Email_108x108.png"];
            
            UILabel * lblemail1Text=[[UILabel alloc]initWithFrame:CGRectMake(50, 15, 300, 30)];
            
            lblemail1Text.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).Email1Text;
            
            //  lblemail1Text.text=@"Test Mail";
            
            UILabel * lblEmail1=[[UILabel alloc]initWithFrame:CGRectMake(50, lblemail1Text.frame.origin.y+lblemail1Text.frame.size.height+3,250, 30)];
            lblEmail1.lineBreakMode = NSLineBreakByWordWrapping;
            lblEmail1.numberOfLines = 0;
            
            
            lblEmail1.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).Email1;
            
            //  lblEmail1.text=@"hjsbdj@nayamode.com";
            
            UIButton * emailBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, emailView.frame.size.width, emailView.frame.size.height)];
            [emailBtn addTarget:self action:@selector(emailclicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [emailView addSubview:emailImgView];
            [emailView addSubview:lblemail1Text];
            [emailView addSubview:lblEmail1];
            [emailView addSubview:emailBtn];
            
            y=emailView.frame.size.height+5;
            
            NSLog(@"%d",y);
            
        }
        
        /******************* Email 2 and 3*****************/
        
        if(objShuttleInfo.Email2 != (id)[NSNull null])
        {
            Email2=[[UILabel alloc]initWithFrame:CGRectMake(10,y, 300, 50)];
            
            Email2.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).Email2;
            
            y=Email2.frame.size.height+5;
            
            NSLog(@"%d",y);
            
        }
        
        if(objShuttleInfo.Email3 != (id)[NSNull null])
        {
            Email3=[[UILabel alloc]initWithFrame:CGRectMake(10,y, 300, 50)];
            
            Email3.text=((shuttleInfo*)[arrShuttleInfo objectAtIndex:i]).Email3;
            
            y=Email3.frame.size.height+5;
            
        }
        
        
        // lblTittle.text=((shuttleInfo*)[APP.shuttleInfoArrayobj objectAtIndex:i]).strTitle;
        // lblDescription.text=((shuttleInfo*)[APP.shuttleInfoArrayobj objectAtIndex:i]).strBriefDescription;
        
        // [lblTittle setBackgroundColor:[UIColor grayColor]];
        //  [lblDescription setBackgroundColor:[UIColor redColor]];
        //  [lblBriefdescription setBackgroundColor:[UIColor grayColor]];
        //  [Phone1View setBackgroundColor:[UIColor redColor]];
        //  [Phone2View setBackgroundColor:[UIColor grayColor]];
        //  [Phone3View setBackgroundColor:[UIColor redColor]];
        //   [emailView setBackgroundColor:[UIColor grayColor]];
        
        //  [Email3 setBackgroundColor:[UIColor grayColor]];
        //  [Emaill2 setBackgroundColor:[UIColor redColor]];
        
        
        [v addSubview:lblTittle];
        [v addSubview:lblDescription];
        [v addSubview:lblBriefdescription];
        
        [v addSubview:Phone1View];
        [v addSubview:Phone2View];
        [v addSubview:Phone3View];
        [v addSubview:emailView];
        
        
        [v addSubview:Email2];
        [v addSubview:Email3];
        
        
        [scrollView addSubview:v];
        x=x+320;
    }
    
    scrollView.pagingEnabled=YES;
    
    //  scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height*2);
    
    scrollView.contentSize=CGSizeMake(x, 800);
    
    [self.view addSubview:scrollView];
    
    //
    //
    //    NSLog(@"data is%@",APP.shuttleInfoArrayobj);
    //    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,backshuttleBtn.frame.origin.y+25, self.view.frame.size.width, self.view.frame.size.height)];
    //
    //    int x = 0;
    //
    //    for (int i = 0; i < [APP.shuttleInfoArrayobj count]; i++)
    //    {
    //        UIView * v=[[UIView alloc]initWithFrame:CGRectMake(0+x, 10, 320, 480)];
    //        //v.backgroundColor=[UIColor grayColor];
    //
    //        [self.view addSubview:v];
    //        UILabel * lblTittle=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 100)];
    //
    //        [lblTittle setBackgroundColor:[UIColor redColor]];
    //
    //        UILabel * lblDescription=[[UILabel alloc]initWithFrame:CGRectMake(10, 100, 200, 100)];
    //        UILabel * lblBriefdescription=[[UILabel alloc]initWithFrame:CGRectMake(10, 100, 200, 100)];
    //
    //        lblTittle.lineBreakMode = NSLineBreakByWordWrapping;
    //        lblTittle.numberOfLines = 0;
    //
    //        lblTittle.text=((shuttleInfo*)[APP.shuttleInfoArrayobj objectAtIndex:i]).strTitle;
    //        lblDescription.text=((shuttleInfo*)[APP.shuttleInfoArrayobj objectAtIndex:i]).strBriefDescription;
    //
    //
    //
    //
    //        [v addSubview:lblTittle];
    //        [v addSubview:lblDescription];
    //
    //
    //        [scrollView addSubview:v];
    //        x=x+320;
    //    }
    //
    //    scrollView.pagingEnabled=YES;
    //
    //    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    //    [self.view addSubview:scrollView];
    
	// Do any additional setup after loading the view.
}

-(void)phone1Clicked:(id)sender
{
    NSLog(@"Button pressed: %ld", (long)[sender tag]);
    
}


-(void)emailclicked:(id)sender
{
    
    
    NSLog(@"Send Mail btn Clicked");
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shuttleInfoBackbtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

