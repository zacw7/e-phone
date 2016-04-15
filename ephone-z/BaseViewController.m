//
//  BaseViewController.m
//  ephone-z
//
//  Created by Jian Liao on 16/3/18.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = self.view.bounds.size.width;
    self.screenHeight = self.view.bounds.size.height;
    self.serverAddress = @"121.42.43.237";
}

- (void)initData {
}

- (void)initViews {
}

@end
