//
//  Sound.m
//  MyGame
//
//  Created by yfzx on 13-11-6.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Sound.h"
#import "SimpleAudioEngine.h"
#import "UserData.h"


@implementation Sound

+(void)playSound:(NSString *)soundName{
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    if ([arr objectForKey:@"SOUND"]) {
        NSString *s = [NSString stringWithFormat:@"%@",[arr objectForKey:@"SOUND"]];
        if ([s isEqualToString:@"1"]) {
            CCLOG(@"************************ 播放音效音乐");
            [[SimpleAudioEngine sharedEngine] playEffect:soundName];
            return;
        } else {
            return;
        }

    }
    [[SimpleAudioEngine sharedEngine] playEffect:soundName];
}

+(void)playBGSound:(NSString *)soundName{
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    if ([arr objectForKey:@"BGSOUND"]) {
        NSString *s = [NSString stringWithFormat:@"%@",[arr objectForKey:@"BGSOUND"]];
        if ([s isEqualToString:@"1"]) {
            CCLOG(@"************************ 播放背景音乐");
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:soundName];
            return;
        } else {
            return;
        }
    
    }
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:soundName];
}

@end
