//
//  MainTabBarViewController.m
//  ephone-z
//
//  Created by Jian Liao on 16/3/7.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "MainTabBarViewController.h"

@implementation MainTabBarViewController {
    GSCall *call;
    NSString *callingNumber;
    BOOL isReceivingCall;
}

@synthesize agent = _agent;
@synthesize account = _account;
@synthesize dialVC = _dialVC;
@synthesize contactsVC = _contactsVC;
@synthesize meVC = _meVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData {
    _dialVC  = [DialViewController new];
    _contactsVC  = [ContactsViewController new];
    _meVC  = [MeViewController new];
    
    _dialVC.delegate = self;
    
    _agent = [GSUserAgent sharedAgent];
    _account = _agent.account;
    _account.delegate = self;
    
    callingNumber = @"";
    isReceivingCall = YES;
}

- (void)initViews {
    _dialVC.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemHistory tag:1];
    _contactsVC.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];
    _meVC.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:3];
    
    self.viewControllers = @[_dialVC, _contactsVC, _meVC];
    //self.customizableViewControllers = @[_dialVC, _contactsVC, _meVC];
    [self setSelectedIndex:0];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.logoutIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.logoutIndicatorView.center = self.view.center;
    NSLog(@"Center: %f, %f", self.logoutIndicatorView.center.x, self.logoutIndicatorView.center.y);  ///////////
    [self.view addSubview: self.logoutIndicatorView];
}

#pragma mark - DialDelegate
- (void)makeDial:(NSString*) dialNumber {
    if([dialNumber isEqualToString:@""]) return;
    callingNumber = dialNumber;
    NSString *address = [[callingNumber stringByAppendingString:@"@"] stringByAppendingString:self.serverAddress]; /////
    NSLog(@"Make a call: %@", address); /////
    call = [GSCall outgoingCallToUri:address fromAccount:_account];
    [self makeCall];
}

#pragma mark - GSAccountDelegate
- (void)account:(GSAccount *)account didReceiveIncomingCall:(GSCall *)incomingCall {
    if(isReceivingCall) isReceivingCall = NO;
    else return;
    NSLog(@"ReceiveIncomingCall");
    call = incomingCall;
    NSString *remote_info_uri = [call getAddress];
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert setDelegate:self];
    [alert setTitle:@"Incoming call."];
    [alert addButtonWithTitle:@"Decline"];
    [alert addButtonWithTitle:@"Answer"];
    [alert setCancelButtonIndex:0];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self userDidDenyCall];
    } else {
        [self userDidPickupCall];
    }
}

- (void)userDidPickupCall {
    [self makeCall];
}

- (void)userDidDenyCall {
    [call end];
    call = nil;
}

- (void)makeCall {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.dialVC.phonePadView.dialBtn.transform = CGAffineTransformMakeRotation(M_PI*3/4);
    } completion:^(BOOL finish){
        [call addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial context:@"callStatusContext"];
        [call begin];
        [self.dialVC.phonePadView.dialBtn setEnabled:NO];
        [self presentCallViewController];
        isReceivingCall = YES;
    }];
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
    switch (call.status) {
        case GSCallStatusReady: {
            NSLog(@"GSCallStatusReady");
        } break;
        case GSCallStatusConnecting: {
            NSLog(@"GSCallStatusConnecting");
        } break;
        case GSCallStatusCalling: {
            NSLog(@"GSCallStatusCalling");
        } break;
        case GSCallStatusConnected: {
            NSLog(@"GSCallStatusConnected");
        } break;
        case GSCallStatusDisconnected: {
            NSLog(@"GSCallStatusDisconnected");
        } break;
    }
}

- (void)presentCallViewController {
    CallViewController *callVC = [CallViewController new];
    callVC.callingNumber = callingNumber;
    callVC.call = call;
    [call removeObserver:self forKeyPath:@"status" context:@"callStatusContext"];
    [self presentViewController:callVC animated:YES completion:^{
        [self.dialVC.phonePadView.dialBtn setEnabled:YES];
        self.dialVC.phonePadView.dialBtn.transform = CGAffineTransformMakeRotation(0);
    }];
}

- (void)logout {
    [self.logoutIndicatorView startAnimating];
    _agent = [GSUserAgent sharedAgent];
    [_agent.account disconnect];
    [_agent reset];
    [self.logoutIndicatorView stopAnimating];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
