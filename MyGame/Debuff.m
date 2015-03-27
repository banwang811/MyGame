//
//  Debuff.m
//  FirstGame
//
//  Created by yfzx on 13-10-25.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Debuff.h"


@implementation Debuff

@synthesize debuffAnimate,debuffCount,dtype;

-(void)dealloc{
    [debuffAnimate release];
    [super dealloc];
}

+(Debuff *)deBuff:(debuff_type)type andPt:(CGPoint)pt{
    switch (type) {
        case debuff_1:
        {
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"yunxuan.plist"];
            Debuff *debuff = [Debuff spriteWithSpriteFrameName:@"yunxuan_1.png"];
            CCAnimate *animate = [debuff Animate:@"yunxuan_" andCount:6 andDelay:0.5/6.0];
            debuff.debuffAnimate = [CCRepeatForever actionWithAction:animate];
            debuff.position = ccp(pt.x + 45, pt.y + 60);
            debuff.debuffCount = 1;
            debuff.dtype = debuff_1;
            debuff.opacity = 160.0f;
            return debuff;
        }
            break;
            
            
        case debuff_2:
        {
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"zengyi.plist"];
            Debuff *debuff = [Debuff spriteWithSpriteFrameName:@"zengyi_1.png"];
            CCAnimate *animate = [debuff Animate:@"zengyi_" andCount:9 andDelay:1/9.0];
            debuff.debuffAnimate = [CCRepeatForever actionWithAction:animate];
            debuff.position = ccp(pt.x + 30, pt.y + 20);
            debuff.debuffCount = 1;
            debuff.dtype = debuff_2;
            debuff.opacity = 160.0f;
            return debuff;
        }
            break;
            
        case debuff_3:
        {
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"zhongdu.plist"];
            Debuff *debuff = [Debuff spriteWithSpriteFrameName:@"zhongdu_1.png"];
            CCAnimate *animate = [debuff Animate:@"zhongdu_" andCount:8 andDelay:1/8.0];
            debuff.debuffAnimate = [CCRepeatForever actionWithAction:animate];
            debuff.position = ccp(pt.x + 40, pt.y);
            debuff.debuffCount = 1;
            debuff.dtype = debuff_3;
            debuff.opacity = 160.0f;
            return debuff;
        }
            break;
            
            
            
        default:
            break;
    }
    
    return nil;
}

-(CCAnimate *)Animate:(NSString *)fileName andCount:(int)count andDelay:(float)delay{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i=1; i<=count; i++) {
        NSString *path = [NSString stringWithFormat:@"%@%d.png",fileName,i];
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:path];
        [array addObject:frame];
    }
    CCAnimation *ation = [CCAnimation animationWithFrames:array delay:delay];
    [array release];
    CCAnimate *animate = [CCAnimate actionWithAnimation:ation];
    return animate;
}

@end
