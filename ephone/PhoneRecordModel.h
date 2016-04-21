//
//  PhoneRecordModel.h
//  ephone
//
//  Created by Jian Liao on 16/4/21.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneRecordModel : NSObject
@property (nonatomic,assign) int dbId;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *phoneNum;
@property (nonatomic,retain) NSString *location;
@property (nonatomic,retain) NSString *call_time;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *myPhoneNum;
@property (nonatomic,retain) NSString *endTime;
@property (nonatomic,retain) NSString *isPlatUpload;
@property (nonatomic,retain) NSString *isItmsUpload;
@property (nonatomic,retain) NSString *currentLocation;
@end