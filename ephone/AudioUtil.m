//
//  AudioUtil.m
//  ephone
//
//  Created by Jian Liao on 16/4/29.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import "AudioUtil.h"

@implementation AudioUtil

static AudioUtil *util=nil;

+ (AudioUtil *)sharedManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        util=[[self alloc]init];
    });
    
    return util;
}

- (id)init {
    self = [super init];
    if (self) {
        sound = nil;
        vibrate = kSystemSoundID_Vibrate; //Vibrate
    }
    return self;
}

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType {
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
        //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
        //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
            
            if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
                sound = nil;
            }
        }
    }
    return self;
}

- (void)playSouldWithName:(NSString *)soundName SoundType:(NSString *)soundType {
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName, soundType];
    //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
    //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
    if (path) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
        if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
            sound = nil;
        }
        AudioServicesPlaySystemSound(sound);
    }
}

- (void)playVibrate {
    AudioServicesPlayAlertSound(vibrate);
}

@end
