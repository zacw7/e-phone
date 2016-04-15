//
//  BaseViewController.h
//  ephone-z
//
//  Created by Jian Liao on 16/3/18.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic) float const screenWidth;
@property (nonatomic) float const screenHeight;
@property (nonatomic) NSString const *serverAddress;

- (void)initData;
- (void)initViews;

@end
