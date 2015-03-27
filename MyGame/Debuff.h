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
} debuff_type;

@interface Debuff : CCSprite {
    
}

@property(nonatomic,assign) int debuffCount;

@property(nonatomic,assign) debuff_type dtype;

@property(nonatomic,retain) CCAnimate *debuffAnimate;

+(Debuff *)deBuff:(debuff_type)type andPt:(CGPoint)pt;

-(CCAnimate *)Animate:(NSString *)fileName andCount:(int)count andDelay:(float)delay;

@end
