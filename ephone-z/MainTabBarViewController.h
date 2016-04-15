//
//  MainTabBarViewController.h
//  ephone-z
//
//  Created by Jian Liao on 16/3/7.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DialViewController.h"
#import "ContactsViewController.h"
#import "MeViewController.h"
#import "CallViewController.h"

#import "Gossip.h"

@interface MainTabBarViewController : UITabBarController <GSAccountDelegate, DialDelegate>

@property (strong, nonatomic) NSString const *username;
@property (strong, nonatomic) NSString const *serverAddress;

@property (strong, nonatomic) GSUserAgent *agent;
@property (strong, nonatomic) GSAccount *account;

@property (strong, nonatomic) DialViewController *dialVC;
@property (strong, nonatomic) ContactsViewController *contactsVC;
@property (strong, nonatomic) MeViewController *meVC;

@property (strong, nonatomic) UIActivityIndicatorView *logoutIndicatorView;

@end
