//
//  ViewController.h
//  ephone-z
//
//  Created by Jian Liao on 16/3/1.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Gossip.h"

#import "MainTabBarViewController.h"

@interface LoginViewController : BaseViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITextField *usernameTF;
@property (strong, nonatomic) UITextField *passwordTF;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIImageView *logoImage;
@property (strong, nonatomic) UIAlertView *invalidUserInfoAlertView;
@property (strong, nonatomic) UIActivityIndicatorView *loginIndicatorView;

@property (nonatomic, assign) BOOL isKeyboardShow;
@property (nonatomic, assign) CGPoint orginCenter;
@property (nonatomic, strong) GSAccount *account;

@end