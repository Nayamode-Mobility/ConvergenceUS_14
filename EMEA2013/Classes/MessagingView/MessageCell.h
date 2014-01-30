//
//  MessageCell.h
//  mgx2013
//
//  Created by Amit Karande on 22/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
{
}

@property (strong, nonatomic) IBOutlet UILabel *lblAttendeeName;
@property (strong, nonatomic) IBOutlet UILabel *lblSubject;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblDate1;
@property (strong, nonatomic) IBOutlet UILabel *lblDate2;
@property (strong, nonatomic) IBOutlet UILabel *lblDate3;
@end
