//
//  CustomTableViewCell.h
//  ephone-z
//
//  Created by Jian Liao on 16/3/8.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *myImageView;
@property (strong, nonatomic) UILabel *myLabel;

- (void)initViews;

@end
