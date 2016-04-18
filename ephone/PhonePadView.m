//
//  PhonePadView.m
//  ephone-z
//
//  Created by Jian Liao on 16/3/11.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "PhonePadView.h"

@implementation PhonePadView

@synthesize contentView, parentView, drawState;
@synthesize arrow;
@synthesize dialBtn;
@synthesize backsapceBtn;

- (id)initWithView:(UIView *) contentview parentView :(UIView *) parentview;
{
    self = [super initWithFrame:CGRectMake(0,0,contentview.frame.size.width, contentview.frame.size.height+40)];
    if (self) {
        // Initialization code
        contentView = contentview;
        parentView = parentview;
        
        //一定要开启
        [parentView setUserInteractionEnabled:YES];
        
        //嵌入内容区域的背景
        UIImage *drawer_bg = [UIImage imageNamed:@"drawer_content.png"];
        UIImageView *view_bg = [[UIImageView alloc] initWithImage:drawer_bg];
        [view_bg setFrame:CGRectMake(0, 40, contentview.frame.size.width, contentview.bounds.size.height+80)];
        [self addSubview:view_bg];
        
        //头部拉拽的区域背景
        UIImage *drawer_handle = [UIImage imageNamed:@"drawer_handlepng.png"];
        UIImageView *view_handle = [[UIImageView alloc]initWithImage:drawer_handle];
        [view_handle setFrame:CGRectMake(0, 0, contentview.frame.size.width, 0)];
        [self addSubview:view_handle];
        
        //箭头的图片
        UIImage *drawer_arrow = [UIImage imageNamed:@"icon_keyboard_on_h.png"];
        arrow = [[UIImageView alloc]initWithImage:drawer_arrow];
        [arrow setFrame:CGRectMake(0, 0, 50 ,50)];
        arrow.center = CGPointMake(contentview.frame.size.width/2, 25);
        [self addSubview:arrow];
        
        //嵌入内容的UIView
        [contentView setFrame:CGRectMake(0, 65, contentview.frame.size.width, contentview.bounds.size.height+40)];
        [self addSubview:contentview];
        
        //移动的手势
        UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRcognize.delegate=self;
        [panRcognize setEnabled:YES];
        [panRcognize delaysTouchesEnded];
        [panRcognize cancelsTouchesInView];
        
        [self addGestureRecognizer:panRcognize];
        
        //单击的手势
        UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        tapRecognize.numberOfTapsRequired = 1;
        tapRecognize.delegate = self;
        [tapRecognize setEnabled :YES];
        [tapRecognize delaysTouchesBegan];
        [tapRecognize cancelsTouchesInView];
        
        [self addGestureRecognizer:tapRecognize];
        
        //设置两个位置的坐标
        downPoint = CGPointMake(parentview.frame.size.width/2, parentview.frame.size.height+contentview.frame.size.height/2-120);
        upPoint = CGPointMake(parentview.frame.size.width/2, parentview.frame.size.height-contentview.frame.size.height/2+60);
        self.center =  downPoint;
        
        //设置起始状态
        drawState = DrawerViewStateDown;
        
        //Set Buttons
        dialBtn = [[UIButton alloc] initWithFrame:arrow.frame];
        UIImage *dial_unselected = [UIImage imageNamed:@"icon_phone.png"];
        [dialBtn setImage:dial_unselected forState:UIControlStateDisabled];
        [dialBtn setImage:dial_unselected forState:UIControlStateNormal];
        dialBtn.enabled = NO;
        [self addSubview:dialBtn];
        
        backsapceBtn = [[UIButton alloc] initWithFrame:arrow.frame];
        UIImage *backspace_unselected = [UIImage imageNamed:@"icon_keyboard_rollback_h.png"];
        [backsapceBtn setImage:backspace_unselected forState:UIControlStateDisabled];
        [backsapceBtn setImage:backspace_unselected forState:UIControlStateNormal];
        backsapceBtn.enabled = NO;
        [self addSubview:backsapceBtn];
        
        [self bringSubviewToFront:arrow];
    }
    return self;
}


#pragma UIGestureRecognizer Handles
/*
 *  移动图片处理的函数
 *  @recognizer 移动手势
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    
    CGPoint translation = [recognizer translationInView:parentView];
    if (self.center.y + translation.y < upPoint.y) {
        self.center = upPoint;
    }else if(self.center.y + translation.y > downPoint.y)
    {
        self.center = downPoint;
    }else{
        self.center = CGPointMake(self.center.x,self.center.y + translation.y);
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:parentView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.75 delay:0.15 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (self.center.y < downPoint.y*4/5) {
                self.center = upPoint;
                [self drawerFullyLaunched:DrawerViewStateUp];
            } else {
                self.center = downPoint;
                [self drawerFullyLaunched:DrawerViewStateDown];
            }
            
        } completion:nil];
        
    }
}

/*
 *  handleTap 触摸函数
 *  @recognizer  UITapGestureRecognizer 触摸识别器
 */
-(void) handleTap:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.5 delay:0.15 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        if (drawState == DrawerViewStateDown) {
            self.center = upPoint;
            [self drawerFullyLaunched:DrawerViewStateUp];
        } else {
            self.center = downPoint;
            [self drawerFullyLaunched:DrawerViewStateDown];
        }
    } completion:nil];
    
}

- (void)drawerFullyLaunched:(DrawerViewState) state {
    [self transformArrow:state];
    
    [UIView animateWithDuration:0.3 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (state == DrawerViewStateUp){
            dialBtn.enabled = YES;
            dialBtn.center = CGPointMake(arrow.center.x-contentView.frame.size.width/3.2, arrow.center.y);
            backsapceBtn.enabled = YES;
            backsapceBtn.transform = CGAffineTransformMakeTranslation(contentView.frame.size.width/3.2, 0);
        } else {
            dialBtn.enabled = NO;
            dialBtn.center = arrow.center;
            backsapceBtn.enabled = NO;
            backsapceBtn.transform = CGAffineTransformMakeTranslation(0, 0);
        }
    } completion:^(BOOL finish){
        drawState = state;
    }];
}

/*
 *  transformArrow 改变箭头方向
 *  state  DrawerViewState 抽屉当前状态
 */
-(void)transformArrow:(DrawerViewState) state {
    //NSLog(@"DRAWERSTATE :%d  STATE:%d",drawState,state);
    [UIView animateWithDuration:0.3 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (state == DrawerViewStateUp){
            arrow.transform = CGAffineTransformMakeRotation(M_PI);
        }else
        {
            arrow.transform = CGAffineTransformMakeRotation(0);
        }
    } completion:^(BOOL finish){
        //drawState = state;
    }];
}

@end

