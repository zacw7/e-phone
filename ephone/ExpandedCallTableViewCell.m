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
    UIButton *dialBtn;
    UIButton *deleteBtn;
    UIButton *saveBtn;
}

@synthesize callRecord = _callRecord;

@synthesize expandView = _expandView;

- (void) initViews{
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
    
    //Set Buttons
    UIImage *dial_unselected = [UIImage imageNamed:@"icon_phone.png"];
    dialBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.4, ORIGIN_Y, CELL_HEIGHT*0.6, CELL_HEIGHT*0.6)];
    [dialBtn setImage:dial_unselected forState:UIControlStateDisabled];
    [dialBtn setImage:dial_unselected forState:UIControlStateNormal];
    dialBtn.enabled = NO;
    [_expandView addSubview:dialBtn];
    
    UIImage *delete_unselected = [UIImage imageNamed:@"icon_delete.png"];
    deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.55, ORIGIN_Y, CELL_HEIGHT*0.6, CELL_HEIGHT*0.6)];
    [deleteBtn setImage:delete_unselected forState:UIControlStateDisabled];
    [deleteBtn setImage:delete_unselected forState:UIControlStateNormal];
    deleteBtn.enabled = NO;
    [_expandView addSubview:deleteBtn];
    
    UIImage *save_unselected = [UIImage imageNamed:@"icon_detail.png"];
    saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(ORIGIN_X + CELL_WIDTH*0.7, ORIGIN_Y, CELL_HEIGHT*0.6, CELL_HEIGHT*0.6)];
    [saveBtn setImage:save_unselected forState:UIControlStateDisabled];
    [saveBtn setImage:save_unselected forState:UIControlStateNormal];
    saveBtn.enabled = NO;
    [_expandView addSubview:saveBtn];

}

@end
