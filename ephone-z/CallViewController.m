//
//  CallViewController.m
//  ephone-z
//
//  Created by Jian Liao on 16/4/14.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "CallViewController.h"

@implementation CallViewController {
    UILabel *statusLabel;
    UILabel *callingNumLabel;
    
    NSTimer *updateTimer;
    
    int hours, minutes, seconds;
    
    DisconnectReason disconnectReason;
}

@synthesize callingNumber = _callingNumber;
@synthesize call = _call;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData {
    hours = minutes = seconds = 0;
    updateTimer = nil;
    disconnectReason = INVALID_NUMBER;
    [_call addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial context:@"callStatusContext"];
}

- (void)initViews {
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenHeight*0.2, self.screenHeight*0.2)];
    test.center = CGPointMake(self.screenWidth*0.25, self.screenHeight*0.25);
    [test setBackgroundColor:[UIColor grayColor]]; //////////
    [self.view addSubview:test];
    
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(test.frame.origin.x + test.frame.size.width + 2,
                                                           test.frame.origin.y,
                                                           self.screenWidth/2,
                                                           self.screenHeight*0.1 - 1)];
    [statusLabel setBackgroundColor:[UIColor grayColor]]; //////////
    statusLabel.text = @"Calling...";
    statusLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:statusLabel];
    
    callingNumLabel = [[UILabel alloc] initWithFrame:statusLabel.frame];
    callingNumLabel.center = CGPointMake(callingNumLabel.center.x,
                                         callingNumLabel.center.y + test.frame.size.height - callingNumLabel.frame.size.height);
    [callingNumLabel setBackgroundColor:[UIColor grayColor]]; //////////
    callingNumLabel.text = _callingNumber;
    callingNumLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:callingNumLabel];
}

#pragma mark - update timerLabel
- (void)timerDone{
    seconds++;
    if(seconds >= 60) {
        seconds = 0;
        minutes++;
        if (minutes>=60) {
            minutes = 0;
            hours++;
        }
    }
    
    statusLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"status"])
        [self callStatusDidChange];
}

- (void)callStatusDidChange {
    switch (_call.status) {
        case GSCallStatusConnected: {
            NSLog(@"GSCallStatusConnected");
            disconnectReason = HANGUP;
            updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerDone) userInfo:nil repeats:YES];
            //            [UIView animateWithDuration:0.3 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //                UIImage *dial_unselected = [UIImage imageNamed:@"icon_phone_on.png"];
            //                [phonePadView.dialBtn setImage:dial_unselected forState:UIControlStateNormal];
            //            } completion:^(BOOL finish){
            //            }];
        } break;
        case GSCallStatusReady: {
            NSLog(@"GSCallStatusReady");
        } break;
        case GSCallStatusConnecting: {
            NSLog(@"GSCallStatusConnecting");
            disconnectReason = REJECTED;
        } break;
        case GSCallStatusCalling: {
            NSLog(@"GSCallStatusCalling");
        } break;
        case GSCallStatusDisconnected: {
            NSLog(@"GSCallStatusDisconnected");
            [_call removeObserver:self forKeyPath:@"status" context:@"callStatusContext"];
            //            [UIView animateWithDuration:0.3 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //                UIImage *dial_unselected = [UIImage imageNamed:@"icon_phone.png"];
            //                [phonePadView.dialBtn setImage:dial_unselected forState:UIControlStateNormal];
            //                phonePadView.dialBtn.transform = CGAffineTransformMakeRotation(M_PI*2);
            //            } completion:^(BOOL finish){
            //                isCalling = NO;
            //                isConnecting = NO;
            //            }];
            [updateTimer invalidate];
            switch (disconnectReason) {
                case INVALID_NUMBER:
                    statusLabel.text = @"Invalid Number";
                    break;
                case REJECTED:
                    statusLabel.text = @"Call Rejected";
                    break;
                case HANGUP:
                    statusLabel.text = @"Disconncted";
                    break;
            }
            [self performSelector:@selector(dissMissSelf) withObject:nil afterDelay:2];
        } break;
            
    }
}

- (void)dissMissSelf{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
