//
//  FAQViewController.h
//  mgx2013
//
//  Created by Amit Karande on 15/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIWebViewDelegate>
{
}

@property (strong, nonatomic) NSArray *arrFAQs;
@property (strong, nonatomic) IBOutlet UICollectionView *categoriesCollectionView;
@property (strong, nonatomic) IBOutlet UIScrollView *svwFAQs;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)MakePhoneCall:(id)sender;
@end
