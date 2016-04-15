//
//  PhonePadView.h
//  ephone-z
//
//  Created by Jian Liao on 16/3/11.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    DrawerViewStateUp = 0,
    DrawerViewStateDown
} DrawerViewState;

@interface PhonePadView : UIView <UIGestureRecognizerDelegate>
{
    UIImageView *arrow;         //向上拖拽时显示的图片
    
    CGPoint upPoint;            //抽屉拉出时的中心点
    CGPoint downPoint;          //抽屉收缩时的中心点
    
    UIView *parentView;         //抽屉所在的view
    UIView *contentView;        //抽屉里面显示的内容
    
    DrawerViewState drawState;  //当前抽屉状态
}

- (id)initWithView:(UIView *) contentview parentView :(UIView *) parentview;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void)handleTap:(UITapGestureRecognizer *)recognizer;
- (void)transformArrow:(DrawerViewState) state;

@property (nonatomic, retain) UIView *parentView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIImageView *arrow;
@property (nonatomic, retain) UIButton *dialBtn;
@property (nonatomic, retain) UIButton *backsapceBtn;
@property (nonatomic) DrawerViewState drawState;

@end
