//
//  PhoneRecordModel.h
//  ephone
//
//  Created by Jian Liao on 16/4/21.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    OUTCOMING = 0,
    INCOMING,
    FAILED,
    MISSED,
} CallType;

typedef enum {
    SIP = 0,
    PSTN,
} NetworkType;

@interface CallRecordModel : NSObject

@property (nonatomic, assign) int dbId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *domain;
@property (nonatomic, retain) NSString *attribution;
@property (nonatomic, retain) NSString *callTime;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic) CallType callType;
@property (nonatomic) NetworkType networkType;

@property (nonatomic, retain) NSString *myAccount;

@end