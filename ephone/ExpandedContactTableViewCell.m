//
//  ExpandedContactTableViewCell.m
//  ephone
//
//  Created by Jian Liao on 16/5/13.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import "ExpandedContactTableViewCell.h"

@implementation ExpandedContactTableViewCell

@synthesize contact = _contact;
@synthesize expandView = _expandView;
@synthesize callBtn = _callBtn;
@synthesize editBtn = _editBtn;
@synthesize deleteBtn = _deleteBtn;

- (void)initViews {
    [super initViews];
    UIImage *expandImage = [UIImage imageNamed:@"icon_up.png"];
    expandImage = [self imageCompressWithSimple:expandImage scale:0.8];
    [super.expandImageView setImage: expandImage];
    
    _contact = super.contact;
    const float CELL_WIDTH = self.frame.size.width;
    const float CELL_HEIGHT = self.frame.size.height;
    const float ORIGIN_X = self.frame.origin.x + CELL_WIDTH*0.03;
    const float ORIGIN_Y = self.frame.origin.y + CELL_WIDTH*0.03;
    
    _expandView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, 60)];
    _expandView.center = CGPointMake(_expandView.center.x, _expandView.center.y + 60);
    [_expandView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    [self addSubview:_expandView];
    
    //Add Buttons
    _callBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.1, ORIGIN_Y, CELL_HEIGHT, CELL_HEIGHT)];
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
    
    _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.4, ORIGIN_Y, CELL_HEIGHT, CELL_HEIGHT)];
    UIImage *editImage = [UIImage imageNamed:@"icon_detail.png"];
    UIImageView *editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, editImage.size.width, editImage.size.height)];
    editImageView.center = CGPointMake(CELL_HEIGHT/2, editImageView.center.y);
    [editImageView setImage:editImage];
    UILabel *editLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT*0.7, CELL_HEIGHT, CELL_HEIGHT*0.42)];
    [editLabel setText:@"Edit"];
    editLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [editLabel setTextColor:[UIColor darkGrayColor]];
    editLabel.textAlignment = NSTextAlignmentCenter;
    [_editBtn addSubview:editImageView];
    [_editBtn addSubview:editLabel];
    [_expandView addSubview:_editBtn];
    
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.7, ORIGIN_Y, CELL_HEIGHT, CELL_HEIGHT)];
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
}

@end
