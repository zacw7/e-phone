//
//  DialViewController.h
//  ephone-z
//
//  Created by Jian Liao on 16/3/11.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "PhonePadView.h"
#import "NumberButton.h"

@protocol DialDelegate <NSObject>
@optional
- (void)makeDial:(NSString*) dialNumber;
@end

@interface DialViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id<DialDelegate> delegate;

@property (nonatomic, assign) float btnWidth;
@property (nonatomic, assign) float btnHeight;
@property (nonatomic, assign) float w;
@property (nonatomic, assign) float h;

@property (weak, nonatomic) UIView *noRecordView;
@property (strong, nonatomic) PhonePadView *phonePadView;

@end