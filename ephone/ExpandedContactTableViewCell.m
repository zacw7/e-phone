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
    UIImage *callImage = [UIImage imageNamed:@"call.png"];
    UIImageView *callImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, callImage.size.width, callImage.size.height)];
    callImageView.center = CGPointMake(CELL_HEIGHT/2, callImageView.center.y);
    [callImageView setImage:callImage];
    [_callBtn addSubview:callImageView];
    [_expandView addSubview:_callBtn];
    
    _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.4, ORIGIN_Y, CELL_HEIGHT, CELL_HEIGHT)];
    UIImage *editImage = [UIImage imageNamed:@"edit.png"];
    UIImageView *editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, editImage.size.width, editImage.size.height)];
    editImageView.center = CGPointMake(CELL_HEIGHT/2, editImageView.center.y);
    [editImageView setImage:editImage];
    [_editBtn addSubview:editImageView];
    [_expandView addSubview:_editBtn];
    
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.7, ORIGIN_Y, CELL_HEIGHT, CELL_HEIGHT)];
    UIImage *deleteImage = [UIImage imageNamed:@"clear.png"];
    UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, deleteImage.size.width, deleteImage.size.height)];
    deleteImageView.center = CGPointMake(CELL_HEIGHT/2, deleteImageView.center.y);
    [deleteImageView setImage:deleteImage];
    [_deleteBtn addSubview:deleteImageView];
    [_expandView addSubview:_deleteBtn];
}

@end
