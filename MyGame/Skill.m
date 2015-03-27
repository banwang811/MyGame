//
//  Skill.m
//  FirstGame
//
//  Created by yfzx on 13-10-25.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Skill.h"


@implementation Skill

@synthesize skillAnimate;

-(void)dealloc{
    [skillAnimate release];
    [super dealloc];
}

+(Skill *)skillWithType:(skill_type)type andPt:(CGPoint)pt{
    switch (type) {
        case skill_1:
        {
            // 闪电
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"shandian.plist"];
            Skill *skill = [Skill spriteWithSpriteFrameName:@"shandian_1.png"];
            CCAnimate *animate = [skill Animate:@"shandian_" andCount:4 andDelay:0.5/8.0];
            skill.skillAnimate = [CCRepeat actionWithAction:animate times:2];
            skill.position = ccp(pt.x, pt.y + 40);
            skill.scale = 0.7f;
            return skill;
            
        }
            break;
            
        case skill_2:
        {
            // 凤凰
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"xiangshanghuofeng.plist"];
            Skill *skill = [Skill spriteWithSpriteFrameName:@"xiangshanghuofeng_1.png"];
            CCAnimate *animate = [skill Animate:@"xiangshanghuofeng_" andCount:4 andDelay:0.5/4.0];
            skill.skillAnimate = [CCRepeat actionWithAction:animate times:2];
            skill.position = ccp(pt.x, pt.y + 50);
            skill.scale = 0.7f;
            return skill;
            
        }
            break;
            
        case skill_3:
        {
            // 凤凰
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"yixinghuanying.plist"];
            Skill *skill = [Skill spriteWithSpriteFrameName:@"yixinghuanying_1.png"];
            skill.skillAnimate = [skill Animate:@"yixinghuanying_" andCount:10 andDelay:1.0/10.0];
            skill.position = ccp(pt.x, pt.y + 30);
            skill.scale = 0.7f;
            return skill;
            
        }
            
        case skill_4:
        {
            // 火石
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"yunshishu.plist"];
            Skill *skill = [Skill spriteWithSpriteFrameName:@"yunshishu_1.png"];
            skill.skillAnimate = [skill Animate:@"yunshishu_" andCount:8 andDelay:1.0/10.0];
            skill.flipX = YES;
            skill.position = ccp(pt.x + 60, pt.y + 80);
            skill.scale = 0.7f;
            return skill;
            
        }
            
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
