//
//  AgendaDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Agenda.h"

@interface AgendaDB : NSObject
{
}

+ (id)GetInstance;

- (NSArray*)GetAgendas;
- (NSArray*)GetAgendasWithAgendaID:(id)strAgendaID;
- (NSArray *)SetAgendas:(NSData*)objData;
@end
