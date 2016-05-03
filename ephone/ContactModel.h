//
//  ContactModel.h
//  ephone
//
//  Created by Jian Liao on 16/5/3.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SIP = 0,
    PSTN,
} NetworkType;

@interface ContactModel : NSObject

@property (nonatomic, assign) int dbId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *domain;
@property (nonatomic, retain) NSString *attribution;
@property (nonatomic) NetworkType networkType;

@property (nonatomic, retain) NSString *myAccount;

@end