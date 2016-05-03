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
    UILabel *callingAddressLabel;
    
    NSTimer *updateTimer;
    
    int hours, minutes, seconds, timeHelper;
    
    DisconnectReason disconnectReason;
    
    UIButton *muteBtn;
    UIButton *holdBtn;
    UIButton *videoBtn;
    UIButton *speakerBtn;
    UIButton *hangupBtn;
    
    float volume, micVol;
    BOOL isConnected, isMute, isHold, isVideo, isSpeaker;
    
    NSString *remoteUriAddress;
    NSString *remoteType;
    NSString *remoteAccount;
    NSString *remoteDomain;
    
    NSString *localUriAddress;
    NSString *localType;
    NSString *localAccount;
    NSString *localDomain;
    
    DBUtil *dbUtil;
    AudioUtil *audioUtil;
}

@synthesize call = _call;
@synthesize crm = _crm;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData {
    dbUtil = [DBUtil sharedManager];
    audioUtil = [AudioUtil sharedManager];
    _crm = [CallRecordModel new];
    
    seconds = -1;
    hours = minutes = 0;
    timeHelper = 1;
    isConnected = isMute = isHold = isVideo = isSpeaker = NO;
    volume = _call.volume;
    micVol = _call.micVolume;
    updateTimer = nil;
    disconnectReason = INVALID_NUMBER;
    remoteUriAddress = [_call getRemoteUri];
    localUriAddress = [_call getLocalUri];
    
    NSArray *remoteArray = [remoteUriAddress componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<:@>"]];
    int shift = 0;
    if([remoteArray[0] isEqualToString:@""]) shift = 1;
    remoteType = remoteArray[0+shift];
    remoteAccount = remoteArray[1+shift];
    remoteDomain = remoteArray[2+shift];
    
    NSArray *localArray = [localUriAddress componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<:@>"]];
    shift = 0;
    if([localArray[0] isEqualToString:@""]) shift = 1;
    localType = localArray[0+shift];
    localAccount = localArray[1+shift];
    localDomain = localArray[2+shift];
    
    [_call addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial context:@"callStatusContext"];
    
    _crm.name = @"";
    _crm.account = remoteAccount;
    _crm.domain = remoteDomain;
    _crm.attribution = @"";
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    _crm.callTime = [df stringFromDate:[NSDate date]];
    
    _crm.networkType = SIP;
    _crm.myAccount = localAccount;
}

- (void)initViews {
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT*0.15, SCREEN_HEIGHT*0.15)];
    test.center = CGPointMake(SCREEN_WIDTH*0.25, SCREEN_HEIGHT*0.2);
    [test setBackgroundColor:[UIColor grayColor]]; //////////
    [self.view addSubview:test];
    
    callingAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(test.frame.origin.x + test.frame.size.width + SCREEN_WIDTH*0.05,
                                                           test.frame.origin.y,
                                                           SCREEN_WIDTH/2,
                                                           SCREEN_HEIGHT*0.1 - 1)];
    //[callingNumLabel setBackgroundColor:[UIColor grayColor]]; //////////
    if([remoteDomain isEqualToString:SERVER_ADDRESS]) callingAddressLabel.text = remoteAccount;
    else callingAddressLabel.text = [[remoteAccount stringByAppendingString:@"@"] stringByAppendingString:remoteDomain];
    callingAddressLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:callingAddressLabel];
    
    statusLabel = [[UILabel alloc] initWithFrame:callingAddressLabel.frame];
    statusLabel.center = CGPointMake(statusLabel.center.x,
                                         statusLabel.center.y + test.frame.size.height - statusLabel.frame.size.height);
    //[statusLabel setBackgroundColor:[UIColor grayColor]]; //////////
    statusLabel.text = @"Connecting...";
    statusLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:statusLabel];
    
    float btnSide = SCREEN_WIDTH*0.25-1;
    
    muteBtn = [[UIButton alloc] initWithFrame:CGRectMake(test.frame.origin.x,
                                                         test.frame.origin.y + test.frame.size.height + SCREEN_HEIGHT*0.06,
                                                         btnSide*1.5, btnSide)];
    [muteBtn.layer setCornerRadius:0];
    [muteBtn.layer setBackgroundColor:[UIColor blackColor].CGColor];
    [muteBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [muteBtn.layer setBorderWidth:1];
    [muteBtn setTitle:@"Mute" forState:UIControlStateNormal];
    [muteBtn addTarget:self action:@selector(muteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:muteBtn];
    
    holdBtn = [[UIButton alloc] initWithFrame:muteBtn.frame];
    holdBtn.center = CGPointMake(holdBtn.center.x + btnSide*1.5 + 1, holdBtn.center.y);
    [holdBtn.layer setCornerRadius:0];
    [holdBtn.layer setBackgroundColor:[UIColor blackColor].CGColor];
    [holdBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [holdBtn.layer setBorderWidth:1];
    [holdBtn setTitle:@"Hold" forState:UIControlStateNormal];
    [holdBtn addTarget:self action:@selector(holdBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:holdBtn];
    
    videoBtn = [[UIButton alloc] initWithFrame:muteBtn.frame];
    videoBtn.center = CGPointMake(videoBtn.center.x, videoBtn.center.y + btnSide + 1);
    [videoBtn.layer setCornerRadius:0];
    [videoBtn.layer setBackgroundColor:[UIColor blackColor].CGColor];
    [videoBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [videoBtn.layer setBorderWidth:1];
    [videoBtn setTitle:@"Video" forState:UIControlStateNormal];
    [videoBtn addTarget:self action:@selector(videoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoBtn];
    
    speakerBtn = [[UIButton alloc] initWithFrame:videoBtn.frame];
    speakerBtn.center = CGPointMake(speakerBtn.center.x + btnSide*1.5 + 1, speakerBtn.center.y);
    [speakerBtn.layer setCornerRadius:0];
    [speakerBtn.layer setBackgroundColor:[UIColor blackColor].CGColor];
    [speakerBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [speakerBtn.layer setBorderWidth:1];
    [speakerBtn setTitle:@"Speaker" forState:UIControlStateNormal];
    [speakerBtn addTarget:self action:@selector(speakerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:speakerBtn];
    
    hangupBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnSide*3, btnSide)];
    hangupBtn.center = CGPointMake(SCREEN_WIDTH/2 - 3, videoBtn.center.y + btnSide + SCREEN_HEIGHT*0.06);
    [hangupBtn.layer setCornerRadius:0];
    [hangupBtn.layer setBackgroundColor:[UIColor redColor].CGColor];
    [hangupBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [hangupBtn.layer setBorderWidth:1];
    [hangupBtn setTitle:@"Hang Up" forState:UIControlStateNormal];
    [hangupBtn addTarget:self action:@selector(hangupBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hangupBtn];
    
    [self setEnabledOfAllButtons:NO];
    [hangupBtn.layer setBackgroundColor:[UIColor redColor].CGColor];
    [hangupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hangupBtn setEnabled:YES];
}

#pragma mark - Button event handler
- (void)muteBtnClicked {
    if(isMute) {
        // Unmute
        if([_call setVolume:volume]) {
            isMute = NO;
            [muteBtn setTitle:@"Unmute" forState:UIControlStateNormal];
            [muteBtn.layer setBackgroundColor:[UIColor blackColor].CGColor];
        }
    } else {
        // Mute
        if([_call setVolume:0]) {
            isMute = YES;
            [muteBtn setTitle:@"Mute" forState:UIControlStateNormal];
            [muteBtn.layer setBackgroundColor:[UIColor grayColor].CGColor];
        }
    }
}

- (void)holdBtnClicked {
    if(isHold) {
        // Unhold
        if([_call setVolume:volume] && [_call setMicVolume:micVol]) {
            isHold = NO;
            timeHelper = 1;
            [holdBtn setTitle:@"Hold" forState:UIControlStateNormal];
            [holdBtn.layer setBackgroundColor:[UIColor blackColor].CGColor];
            //[holdBtn.layer setBorderWidth:1];
        }
    } else {
        // Hold
        if([_call setVolume:0] && [_call setMicVolume:0]) {
            isHold = YES;
            timeHelper = 0;
            [holdBtn setTitle:@"Unhold" forState:UIControlStateNormal];
            [holdBtn.layer setBackgroundColor:[UIColor grayColor].CGColor];
        }
    }
}

- (void)videoBtnClicked {
    if(isVideo) {
        // Close Video
        isVideo = NO;
        [videoBtn.layer setBackgroundColor:[UIColor blackColor].CGColor];
    } else {
        // Open Video
        isVideo = YES;
        [videoBtn.layer setBackgroundColor:[UIColor grayColor].CGColor];
        
        // TODO
    }
}

- (void)speakerBtnClicked {
    if(isSpeaker) {
        // Use headphone
        isSpeaker = NO;
        [speakerBtn setTitle:@"Speaker" forState:UIControlStateNormal];
        [speakerBtn.layer setBackgroundColor:[UIColor blackColor].CGColor];
        [audioUtil setHeadphone];
    } else {
        // Use Speaker
        isSpeaker = YES;
        [speakerBtn setTitle:@"Headphone" forState:UIControlStateNormal];
        [speakerBtn.layer setBackgroundColor:[UIColor grayColor].CGColor];
        [audioUtil setSpeaker];
    }
}

- (void)hangupBtnClicked {
    disconnectReason = HANGUP;
    [_call end];
}

- (void)setEnabledOfAllButtons:(BOOL)enabled {
    [muteBtn setEnabled:enabled];
    [holdBtn setEnabled:enabled];
    [videoBtn setEnabled:enabled];
    [speakerBtn setEnabled:enabled];
    [hangupBtn setEnabled:enabled];
    if(enabled) {
        [muteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [holdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [speakerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [hangupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [hangupBtn.layer setBackgroundColor:[UIColor redColor].CGColor];
    } else {
        [muteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [holdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [videoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [speakerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [hangupBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [hangupBtn.layer setBackgroundColor:[UIColor blackColor].CGColor];
    }
}

#pragma mark - Update timerLabel
- (void)timerDone{
    seconds += timeHelper;
    if(seconds >= 60) {
        seconds = 0;
        minutes++;
        if (minutes>=60) {
            minutes = 0;
            hours++;
        }
    }
    NSLog(@"Duration: %02d:%02d:%02d", hours, minutes, seconds);
    statusLabel.text = [NSString stringWithFormat:@"Duration: %02d:%02d:%02d", hours, minutes, seconds];
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
            [self setEnabledOfAllButtons:YES];
            isConnected = YES;
            disconnectReason = HANGUP;
            if(!updateTimer)
                updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerDone) userInfo:nil repeats:YES];
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
            [self setEnabledOfAllButtons:NO];
            [_call removeObserver:self forKeyPath:@"status" context:@"callStatusContext"];
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
            [self performSelector:@selector(dissMissSelf) withObject:nil afterDelay:2.5];
            if(isConnected) {
                _crm.duration = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
            } else {
                _crm.duration = @"--:--:--";
                if(_crm.callType == INCOMING) _crm.callType = MISSED;
                else if(_crm.callType == OUTCOMING) _crm.callType = FAILED;
            }
        } break;
            
    }
}

- (void)dissMissSelf{
    NSLog(@"crm %@", _crm);
    if(_crm.myAccount) [dbUtil insertRecentContactsRecord:_crm];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
