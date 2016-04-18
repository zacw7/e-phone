//
//  MeViewController.h
//  ephone-z
//
//  Created by Jian Liao on 16/3/8.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomTableViewCell.h"

@interface MeViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *listMe;

@end