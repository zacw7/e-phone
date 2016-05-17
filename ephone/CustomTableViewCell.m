//
//  CustomTableViewCell.m
//  ephone-z
//
//  Created by Jian Liao on 16/3/8.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

@synthesize myImageView = _myImageView;
@synthesize myLabel = _myLabel;

-(void)initViews {
    const float CELL_WIDTH = self.frame.size.width;
    const float CELL_HEIGHT = self.frame.size.height;
    const float ORIGIN_X = self.frame.origin.x + CELL_WIDTH*0.03;
    const float ORIGIN_Y = self.frame.origin.y + CELL_WIDTH*0.03;
    
    _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y, CELL_HEIGHT, CELL_HEIGHT)];
    [self addSubview:_myImageView];
    
    _myLabel = [[UILabel alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.2, ORIGIN_Y, CELL_WIDTH*0.5, CELL_HEIGHT)];
    [self addSubview:_myLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
