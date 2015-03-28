//
//  Debuff.h
//  FirstGame
//
//  Created by yfzx on 13-10-25.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    debuff_1 = 1,
    debuff_2 = 2,
    debuff_3 = 3,
    debuff_4 = 4,
    
    other_1 = 100,
} debuff_type;

@interface Debuff : CCSprite {
    
}
// debuff持续回合数
@property(nonatomic,assign) int debuffCount;
// debuff类型
@property(nonatomic,assign) debuff_type dtype;
// debuff动画
@property(nonatomic,retain) CCAnimate *debuffAnimate;

@property(nonatomic,assign) int ATN; // 物理伤害
@property(nonatomic,assign) int ITN; // 魔法伤害
@property(nonatomic,assign) int sleepTimes; // 休息回合数

//+(Debuff *)deBuff:(debuff_type)type andPt:(CGPoint)pt;

+(Debuff *)deBuff:(debuff_type)type;

-(void)setDebuffPt:(CGPoint)pt;

-(CCAnimate *)Animate:(NSString *)fileName andCount:(int)count andDelay:(float)delay;

@end
