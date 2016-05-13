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
#import "NewContactView.h"
#import "NumberButton.h"
#import "CallRecordModel.h"
#import "CallTableViewCell.h"
#import "ExpandedCallTableViewCell.h"
#import "DBUtil.h"

@interface DialViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) id<DialDelegate> delegate;

@property (nonatomic, assign) float btnWidth;
@property (nonatomic, assign) float btnHeight;
@property (nonatomic, assign) float w;
@property (nonatomic, assign) float h;

@property (nonatomic, assign) const NSString *myAccount;

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIView *noRecordView;
@property (strong, nonatomic) UITableView *recordTableView;
@property (strong, nonatomic) PhonePadView *phonePadView;

@property (strong, nonatomic) NewContactView *addContactView;

@end