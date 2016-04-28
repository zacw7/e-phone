//
//  MainTabBarViewController.m
//  ephone-z
//
//  Created by Jian Liao on 16/3/7.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "MainTabBarViewController.h"

@implementation MainTabBarViewController {
    DBUtil *dbUtil;
    GSCall *call;
    CallRecordModel *crm;
    UIAlertView *incomingAlert;
    
    NSString *callingNumber;
    
    BOOL isReceivingCall;
    BOOL isIncomingCallRinging;
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
    dbUtil = [DBUtil sharedManager];
    _dialVC  = [DialViewController new];
    _contactsVC  = [ContactsViewController new];
    _meVC  = [MeViewController new];
    
    _dialVC.delegate = self;
    _dialVC.myAccount = self.username;
    
    _agent = [GSUserAgent sharedAgent];
    _account = _agent.account;
    _account.delegate = self;
    
    callingNumber = @"";
    isReceivingCall = YES;
    isIncomingCallRinging = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(incomingCallDisconnected)
                                                 name:GSSIPCallStateDidChangeNotification
                                               object:nil];
}

- (void)initViews {
    _dialVC.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemHistory tag:1];
    _contactsVC.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];
    _meVC.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:3];
    
    self.viewControllers = @[_dialVC, _contactsVC, _meVC];
    [self setSelectedIndex:0];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.logoutIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.logoutIndicatorView.center = self.view.center;
    [self.view addSubview: self.logoutIndicatorView];
}

#pragma mark - DialDelegate
- (void)makeSipCall:(NSString*) sipUri {
    call = [GSCall outgoingCallToUri:sipUri fromAccount:_account];
    [self makeCall:OUTCOMING];
}

#pragma mark - GSAccountDelegate
- (void)account:(GSAccount *)account didReceiveIncomingCall:(GSCall *)incomingCall {
    if(isReceivingCall) isReceivingCall = NO;
    else return;
    isIncomingCallRinging = YES;
    call = incomingCall;
    
    crm = [CallRecordModel new];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    crm.callTime = [df stringFromDate:[NSDate date]];
    
    NSString *remoteUriAddress = [call getRemoteUri];
    NSArray *remoteArray = [remoteUriAddress componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<:@>"]];
    int shift = 0;
    if([remoteArray[0] isEqualToString:@""]) shift = 1;
    NSString *remoteAccount = remoteArray[1+shift];
    NSString *remoteDomain = remoteArray[2+shift];
    
    crm.account = remoteAccount;
    crm.domain = remoteDomain;
    crm.myAccount = (NSString *)self.username;
    
    incomingAlert = [[UIAlertView alloc] init];
    [incomingAlert setAlertViewStyle:UIAlertViewStyleDefault];
    [incomingAlert setDelegate:self];
    [incomingAlert setTitle:@"Incoming call."];
    [incomingAlert addButtonWithTitle:@"Decline"];
    [incomingAlert addButtonWithTitle:@"Answer"];
    [incomingAlert setCancelButtonIndex:0];
    [incomingAlert show];
}

- (void)incomingCallDisconnected {
    if(isIncomingCallRinging) {
        [incomingAlert dismissWithClickedButtonIndex:[incomingAlert cancelButtonIndex] animated:YES];
        isIncomingCallRinging = NO;
        isReceivingCall = YES;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self userDidDenyCall];
    } else {
        [self userDidPickupCall];
    }
    isIncomingCallRinging = NO;
}

- (void)userDidPickupCall {
    [self makeCall:INCOMING];
}

- (void)userDidDenyCall {
    [self addMissedCallRecord];
    [call end];
    call = nil;
}

- (void)addMissedCallRecord {
    crm.name = @"";
    crm.attribution = @"";
    crm.duration = @"--:--:--";
    crm.callType = MISSED;
    crm.networkType = SIP;
    
    [dbUtil insertRecentContactsRecord:crm];
}

- (void)makeCall:(CallType) callType {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.dialVC.phonePadView.dialBtn.transform = CGAffineTransformMakeRotation(M_PI*3/4);
    } completion:^(BOOL finish){
        [call addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial context:@"callStatusContext"];
        [call begin];
        [self.dialVC.phonePadView.dialBtn setEnabled:NO];
        CallViewController *callVC = [CallViewController new];
        callVC.call = call;
        [call removeObserver:self forKeyPath:@"status" context:@"callStatusContext"];
        [self presentViewController:callVC animated:YES completion:^{
            [self.dialVC.phonePadView.dialBtn setEnabled:YES];
            self.dialVC.phonePadView.dialBtn.transform = CGAffineTransformMakeRotation(0);
            callVC.crm.callType = callType;
        }];
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
            NSLog(@"Main: GSCallStatusReady");
        } break;
        case GSCallStatusConnecting: {
            NSLog(@"Main: GSCallStatusConnecting");
        } break;
        case GSCallStatusCalling: {
            NSLog(@"Main: GSCallStatusCalling");
        } break;
        case GSCallStatusConnected: {
            NSLog(@"Main: GSCallStatusConnected");
        } break;
        case GSCallStatusDisconnected: {
            NSLog(@"Main: GSCallStatusDisconnected");
        } break;
    }
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
