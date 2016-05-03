//
//  CallViewController.h
//  ephone-z
//
//  Created by Jian Liao on 16/4/14.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DBUtil.h"
#import "AudioUtil.h"
#import "CallRecordModel.h"

#import "Gossip.h"

typedef enum
{
    INVALID_NUMBER = 0,
    REJECTED,
    HANGUP
} DisconnectReason;

@interface CallViewController : UIViewController

@property (strong, nonatomic) GSCall *call;
@property (strong, nonatomic) CallRecordModel *crm;

@end