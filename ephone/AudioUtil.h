//
//  AudioUtil.h
//  ephone
//
//  Created by Jian Liao on 16/4/29.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolBox/AudioToolBox.h>

@interface AudioUtil : NSObject {
    SystemSoundID vibrate;
    SystemSoundID sound; // 1000-2000
}

+ (AudioUtil *) sharedManager; //获取单例对象
- (id)initSystemVibrate; //Vibrate
- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType; //初始化系统声音
- (void)playSound;
- (void)playVibrate;

@end
