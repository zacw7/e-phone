//
//  NumberButton.m
//  ephone-z
//
//  Created by Jian Liao on 16/3/11.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "NumberButton.h"

@implementation NumberButton

- (instancetype)initWithNumber:(NSUInteger)number letters:(NSString *)letters {
    self = [super init];
    if (self)
    {
        _number = number;
        _letters = letters;
        [self setBackgroundImage:nil forState:UIControlStateNormal];
        
        if (letters)
        {
            _lettersLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 19.125, 64, 20)];
            _lettersLabel.text = letters;
            _lettersLabel.textColor = [UIColor whiteColor];
            _lettersLabel.textAlignment = NSTextAlignmentCenter;
            _lettersLabel.font = [UIFont systemFontOfSize:18.0f];
            [self addSubview:_lettersLabel];
        }
    }
    return self;
}

- (void)pressed:(UIButton *)sender {
}

- (void)tintColorDidChange {
    self.layer.borderColor = [self.tintColor CGColor];
    self.numberLabel.textColor = self.tintColor;
    self.lettersLabel.textColor = self.tintColor;
}


@end
