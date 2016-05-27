//
//  ExpandedCallTableViewCell.m
//  ephone
//
//  Created by Jian Liao on 16/4/22.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import "ExpandedCallTableViewCell.h"

@implementation ExpandedCallTableViewCell {
    UILabel *durationLabel;
}

@synthesize callRecord = _callRecord;
@synthesize expandView = _expandView;
@synthesize callBtn = _callBtn;
@synthesize deleteBtn = _deleteBtn;
@synthesize saveBtn = _saveBtn;

- (void)initViews {
    [super initViews];
    UIImage *expandImage = [UIImage imageNamed:@"icon_up.png"];
    expandImage = [self imageCompressWithSimple:expandImage scale:0.8];
    [super.expandImageView setImage: expandImage];
    
    _callRecord = super.callRecord;
    const float CELL_WIDTH = self.frame.size.width;
    const float CELL_HEIGHT = self.frame.size.height;
    const float ORIGIN_X = self.frame.origin.x + CELL_WIDTH*0.03;
    const float ORIGIN_Y = self.frame.origin.y + CELL_WIDTH*0.03;
    
    _expandView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, 60)];
    _expandView.center = CGPointMake(_expandView.center.x, _expandView.center.y + 60);
    [_expandView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    [self addSubview:_expandView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y, CELL_WIDTH*0.25, CELL_HEIGHT/2)];
    titleLabel.text = @"Duration";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [_expandView addSubview:titleLabel];

    durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y + CELL_HEIGHT*0.5, CELL_WIDTH*0.25, CELL_HEIGHT/2)];
    durationLabel.text = _callRecord.duration;
    durationLabel.textColor = [UIColor darkGrayColor];
    durationLabel.textAlignment = NSTextAlignmentCenter;
    [_expandView addSubview:durationLabel];
    
    UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.3, ORIGIN_Y, 1, CELL_HEIGHT)];
    [splitLine setBackgroundColor:[UIColor grayColor]];
    [_expandView addSubview:splitLine];
    
    //Add Buttons
    _callBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.35, ORIGIN_Y, CELL_HEIGHT, CELL_HEIGHT)];
    UIImage *callImage = [UIImage imageNamed:@"call.png"];
    UIImageView *callImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, callImage.size.width, callImage.size.height)];
    callImageView.center = CGPointMake(CELL_HEIGHT/2, callImageView.center.y);
    [callImageView setImage:callImage];
    [_callBtn addSubview:callImageView];
    [_expandView addSubview:_callBtn];
    
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.525, ORIGIN_Y, CELL_HEIGHT, CELL_HEIGHT)];
    UIImage *deleteImage = [UIImage imageNamed:@"clear.png"];
    UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, deleteImage.size.width, deleteImage.size.height)];
    deleteImageView.center = CGPointMake(CELL_HEIGHT/2, deleteImageView.center.y);
    [deleteImageView setImage:deleteImage];
    [_deleteBtn addSubview:deleteImageView];
    [_expandView addSubview:_deleteBtn];
    
    _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.7, ORIGIN_Y, CELL_HEIGHT, CELL_HEIGHT)];
    UIImage *saveImage = [UIImage imageNamed:@"person_add.png"];
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, saveImage.size.width, saveImage.size.height)];
    saveImageView.center = CGPointMake(CELL_HEIGHT/2, saveImageView.center.y);
    [saveImageView setImage:saveImage];
    [_saveBtn addSubview:saveImageView];
    [_expandView addSubview:_saveBtn];
}

@end
