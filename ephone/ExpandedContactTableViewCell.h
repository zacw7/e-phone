//
//  ExpandedContactTableViewCell.h
//  ephone
//
//  Created by Jian Liao on 16/5/13.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactTableViewCell.h"

@interface ExpandedContactTableViewCell : ContactTableViewCell

@property (strong, nonatomic) UIView *expandView;

@property (strong, nonatomic) UIButton *callBtn;
@property (strong, nonatomic) UIButton *editBtn;
@property (strong, nonatomic) UIButton *deleteBtn;

@end
