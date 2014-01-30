
#import "StyledPullableView.h"
#import "SyncUp.h"

/**
 @author Fabio Rodella fabio@crocodella.com.br
 */

@implementation StyledPullableView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1.0];

        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slideout_icon.png"]];
        imgView.frame = CGRectMake(270, 2, 40, 16);
        [self addSubview:imgView];

        UIButton *btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, 46, 46)];
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"search_92x92.png"] forState:UIControlStateNormal];
        [self addSubview:btnSearch];

        UITapGestureRecognizer *tapSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadSearch:)];
        [btnSearch addGestureRecognizer:tapSearch];

        UIButton *btnResources = [[UIButton alloc] initWithFrame:CGRectMake(104, 20, 46, 46)];
        [btnResources setBackgroundImage:[UIImage imageNamed:@"resources_92x92.png"] forState:UIControlStateNormal];
        [self addSubview:btnResources];

        UITapGestureRecognizer *tapResource = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadResources:)];
        [btnResources addGestureRecognizer:tapResource];

        UIButton *btnRefresh = [[UIButton alloc] initWithFrame:CGRectMake(168, 20, 46, 46)];
        [btnRefresh setBackgroundImage:[UIImage imageNamed:@"refresh_92x92.png"] forState:UIControlStateNormal];
        [self addSubview:btnRefresh];

        UITapGestureRecognizer *tapRefresh = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshData:)];
        [btnRefresh addGestureRecognizer:tapRefresh];

        UIButton *btnLogout = [[UIButton alloc] initWithFrame:CGRectMake(232, 20, 46, 46)];
        [btnLogout setBackgroundImage:[UIImage imageNamed:@"logout_92x92.png"] forState:UIControlStateNormal];
        [self addSubview:btnLogout];

        UITapGestureRecognizer *tapLogout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout:)];
        [btnLogout addGestureRecognizer:tapLogout];
    }
    
    return self;
}

- (void)refreshData:(UITapGestureRecognizer*)gesture
{
    [self setOpened:NO animated:YES];
    if ([delegate respondsToSelector:@selector(pullableView:refreshData:)])
    {
        [delegate pullableView:self refreshData:gesture];
    }
}

- (void)logout:(UITapGestureRecognizer*)gesture
{
    [self setOpened:NO animated:YES];
    if ([delegate respondsToSelector:@selector(pullableView:logout:)])
    {
        [delegate pullableView:self logout:gesture];
    }
}

- (void)loadSearch:(UITapGestureRecognizer*)gesture
{
    [self setOpened:NO animated:YES];
    if ([delegate respondsToSelector:@selector(pullableView:loadSearch:)])
    {
        [delegate pullableView:self loadSearch:gesture];
    }
}

- (void)loadResources:(UITapGestureRecognizer*)gesture
{
    [self setOpened:NO animated:YES];
    if ([delegate respondsToSelector:@selector(pullableView:loadResources:)])
    {
        [delegate pullableView:self loadResources:gesture];
    }
}

@end
