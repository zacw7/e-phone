//
//  AudioUtil.h
//  ephone
//
//  Created by Jian Liao on 16/4/29.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioUtil : NSObject {
    AVAudioSession *audioSession;
    NSTimer *vibrateTimer;
}

@property (strong, nonatomic) AVAudioPlayer *player;

+ (AudioUtil *) sharedManager; //获取单例对象
- (void)playSoundOnce;
- (void)playSoundConstantly;
- (void)playVibrateOnce;
- (void)playVibrateConstantly;
- (void)stop;

- (void)setSpeaker;
- (void)setHeadphone;

@end
