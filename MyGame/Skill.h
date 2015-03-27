//
//  Skill.h
//  FirstGame
//
//  Created by yfzx on 13-10-25.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    skill_1 = 1, // 闪电
    skill_2 = 2, // 火凤
    skill_3 = 3, // yixinghuanying
    skill_4 = 4, // yunshishu
} skill_type;

@interface Skill : CCSprite {
    
}

@property(nonatomic,retain) CCAnimate *skillAnimate;

+(Skill *)skillWithType:(skill_type)type andPt:(CGPoint)pt;

-(CCAnimate *)Animate:(NSString *)fileName andCount:(int)count andDelay:(float)delay;

@end
