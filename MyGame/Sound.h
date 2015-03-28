//
//  Sound.h
//  MyGame
//
//  Created by yfzx on 13-11-6.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Sound : NSObject {
    
}

+(void)playSound:(NSString *)soundName;

+(void)playBGSound:(NSString *)soundName;

@end
