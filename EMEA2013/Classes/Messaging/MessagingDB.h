//
//  MessagingDB.h
//  mgx2013
//
//  Created by Amit Karande on 22/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessagingDB : NSObject
{
    
}

+ (id)GetInstance;

- (NSArray*)GetInboxMessages;
- (NSArray*)GetSentboxMessages;
- (NSArray*)GetDraftMessages;
- (BOOL)SetMessages:(NSData*)objData;
- (BOOL)AddMessage:(Message*)objMesssage TableName:(NSString *)strTableName;
- (BOOL)UpdateMessage:(Message*)objMessage TableName:(NSString *)strTableName;
- (NSInteger) AddDraftMessage:(Message*)objMessage;
- (BOOL) UpdateSentMessage:(NSInteger)intMessageID;
- (BOOL) DeleteMessage:(NSString *)strMessageID TableName:(NSString *)strTableName;
- (BOOL)DeleteSentMessages;
@end
