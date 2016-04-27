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
    UIImage *callImage = [UIImage imageNamed:@"icon_phone.png"];
    UIImageView *callImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, callImage.size.width, callImage.size.height)];
    callImageView.center = CGPointMake(CELL_HEIGHT/2, callImageView.center.y);
    [callImageView setImage:callImage];
    UILabel *callLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT*0.7, CELL_HEIGHT, CELL_HEIGHT*0.42)];
    [callLabel setText:@"Call"];
    callLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [callLabel setTextColor:[UIColor darkGrayColor]];
    callLabel.textAlignment = NSTextAlignmentCenter;
    [_callBtn addSubview:callImageView];
    [_callBtn addSubview:callLabel];
    [_expandView addSubview:_callBtn];
    
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.525, ORIGIN_Y, CELL_HEIGHT, CELL_HEIGHT)];
    UIImage *deleteImage = [UIImage imageNamed:@"icon_delete.png"];
    UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, deleteImage.size.width, deleteImage.size.height)];
    deleteImageView.center = CGPointMake(CELL_HEIGHT/2, deleteImageView.center.y);
    [deleteImageView setImage:deleteImage];
    UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT*0.7, CELL_HEIGHT, CELL_HEIGHT*0.42)];
    [deleteLabel setText:@"Delete"];
    deleteLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [deleteLabel setTextColor:[UIColor darkGrayColor]];
    deleteLabel.textAlignment = NSTextAlignmentCenter;
    [_deleteBtn addSubview:deleteImageView];
    [_deleteBtn addSubview:deleteLabel];
    [_expandView addSubview:_deleteBtn];
    
    _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.7, ORIGIN_Y, CELL_HEIGHT, CELL_HEIGHT)];
    UIImage *saveImage = [UIImage imageNamed:@"icon_detail.png"];
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, saveImage.size.width, saveImage.size.height)];
    saveImageView.center = CGPointMake(CELL_HEIGHT/2, saveImageView.center.y);
    [saveImageView setImage:saveImage];
    UILabel *saveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT*0.7, CELL_HEIGHT, CELL_HEIGHT*0.42)];
    [saveLabel setText:@"Save"];
    saveLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [saveLabel setTextColor:[UIColor darkGrayColor]];
    saveLabel.textAlignment = NSTextAlignmentCenter;
    [_saveBtn addSubview:saveImageView];
    [_saveBtn addSubview:saveLabel];
    [_expandView addSubview:_saveBtn];
}

@end
