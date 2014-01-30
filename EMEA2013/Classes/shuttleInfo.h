//
//  shuttleInfo.h
//  ConvergenceUSA_2014
//
//  Created by Nayamode on 15/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface shuttleInfo : NSObject
{
    NSString *ShuttleInfoId;
    NSString *strTitle;
    NSString *strBriefDescription;
    NSString *strBriefDescription2;
    NSString *Phone1;
    NSString *Phone2;
    NSString *Phone3;
    NSString *Phone1Text;
    NSString *Phone2Text;
    NSString *Phone3Text;
    NSString *Email1;
    NSString *Email2;
    NSString *Email3;
    NSString *Email1Text;
    NSString *Email2Text;
    NSString *Email3Text;
}
@property (nonatomic, retain) NSString *strTitle;
@property (nonatomic, retain) NSString *strBriefDescription;
@property (nonatomic, retain) NSString *ShuttleInfoId;
@property (nonatomic, retain) NSString *strBriefDescription2;
@property (nonatomic, retain) NSString *Phone1;
@property (nonatomic, retain) NSString *Phone2;
@property (nonatomic, retain) NSString *Phone3;
@property (nonatomic, retain) NSString *Phone1Text;
@property (nonatomic, retain) NSString *Phone2Text;
@property (nonatomic, retain) NSString *Phone3Text;
@property (nonatomic, retain) NSString *Email1;
@property (nonatomic, retain) NSString *Email2;
@property (nonatomic, retain) NSString *Email3;
@property (nonatomic, retain) NSString *Email1Text;
@property (nonatomic, retain) NSString *Email2Text;
@property (nonatomic, retain) NSString *Email3Text;

@end
