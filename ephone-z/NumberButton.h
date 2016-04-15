//
//  NumberButton.h
//  ephone-z
//
//  Created by Jian Liao on 16/3/11.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberButton : UIButton

@property (nonatomic, readonly, assign) NSUInteger number;
@property (nonatomic, readonly, copy) NSString *letters;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *lettersLabel;

@property (nonatomic, strong) UIColor *backgroundColorBackup;

- (instancetype)initWithNumber:(NSUInteger)number letters:(NSString *)letters;

@end
