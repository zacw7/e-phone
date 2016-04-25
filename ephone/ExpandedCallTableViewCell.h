//
//  ExpandedCallTableViewCell.h
//  ephone
//
//  Created by Jian Liao on 16/4/22.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallTableViewCell.h"

@interface ExpandedCallTableViewCell : CallTableViewCell

@property (strong, nonatomic) UIView *expandView;

@property (strong, nonatomic) UIButton *callBtn;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UIButton *saveBtn;

@end
