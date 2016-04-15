//
//  CallViewController.h
//  ephone-z
//
//  Created by Jian Liao on 16/4/14.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "Gossip.h"

typedef enum
{
    INVALID_NUMBER = 0,
    REJECTED,
    HANGUP
} DisconnectReason;

@interface CallViewController : BaseViewController

@property (strong, nonatomic) NSString *callingNumber;
@property (strong, nonatomic) GSCall *call;

@end
