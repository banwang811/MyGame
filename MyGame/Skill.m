//
//  Skill.m
//  FirstGame
//
//  Created by yfzx on 13-10-25.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Skill.h"


@implementation Skill

@synthesize skillAnimate,skillIcon,lev,INT,skillName,skillNameSprite,debuff,type,skillDescription,debuffProbability;

-(void)dealloc{
    
    [skillIcon release];
    [skillAnimate release];
    [skillName release];
    [skillNameSprite release];
    if (debuff) {
        [debuff release];
    }
    if (skillDescription) {
        [skillDescription release];
    }
    [super dealloc];
}

// 设置技能坐标
-(void)setSkillPt:(CGPoint)pt{
    switch (self.type) {
        case skill_1:
            self.position = ccp(pt.x, pt.y + 40);
            break;
            
        case skill_2:
            self.position = ccp(pt.x, pt.y + 50);
            break;
            
        case skill_3:
            self.position = ccp(pt.x, pt.y + 30);
            break;
            
        case skill_4:
            self.position = ccp(pt.x + 60, pt.y + 80);
            break;
            
        default:
            break;
    }
}

+(Skill *)skillWithType:(skill_type)type{
    Skill *skill;
//    CCLOG(@"===================================== %d",type);
    switch (type) {
        case skill_1:
        {
            // 闪电
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"shandian.plist"];
            skill = [Skill spriteWithSpriteFrameName:@"shandian_1.png"];
            CCAnimate *animate = [skill Animate:@"shandian_" andCount:4 andDelay:0.5/8.0];
            skill.skillAnimate = [CCRepeat actionWithAction:animate times:2];
//            skill.position = ccp(pt.x, pt.y + 40);
            skill.scale = 0.7f;
            skill.skillIcon = @"skill_101.png";
            skill.skillName = @"然木刀法";
            skill.skillNameSprite = @"skillh_121.png";
            skill.debuff = [Debuff deBuff:debuff_1];
            skill.type = skill_1;
            skill.skillDescription = [NSString stringWithFormat:@"传说中的‘然木刀法’,附加掉血debuff持续%d回合,每回合掉血%d",skill.debuff.debuffCount,skill.debuff.ATN];
            skill.debuffProbability = 100;
            
        }
            break;
            
        case skill_2:
        {
            // 凤凰
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"xiangshanghuofeng.plist"];
            skill = [Skill spriteWithSpriteFrameName:@"xiangshanghuofeng_1.png"];
            CCAnimate *animate = [skill Animate:@"xiangshanghuofeng_" andCount:4 andDelay:0.5/4.0];
            skill.skillAnimate = [CCRepeat actionWithAction:animate times:2];
//            skill.position = ccp(pt.x, pt.y + 50);
            skill.scale = 0.7f;
            skill.skillIcon = @"skill_102.png";
            skill.skillName = @"混沌剑法";
            skill.skillNameSprite = @"skillh_1201.png";
            skill.debuff = [Debuff deBuff:debuff_2];
            skill.type = skill_2;
            skill.skillDescription = [NSString stringWithFormat:@"传说中的‘混沌剑法’,附加中毒debuff持续%d回合,每回合掉血%d",skill.debuff.debuffCount,skill.debuff.ATN];
            skill.debuffProbability = 100;
            
        }
            break;
            
        case skill_3:
        {
            // 凤凰
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"yixinghuanying.plist"];
            skill = [Skill spriteWithSpriteFrameName:@"yixinghuanying_1.png"];
            skill.skillAnimate = [skill Animate:@"yixinghuanying_" andCount:10 andDelay:1.0/10.0];
//            skill.position = ccp(pt.x, pt.y + 30);
            skill.scale = 0.7f;
            skill.skillIcon = @"skill_103.png";
            skill.skillName = @"噬日刀";
            skill.skillNameSprite = @"skillh_1202.png";
            skill.debuff = [Debuff deBuff:debuff_3];
            skill.type = skill_3;
            skill.skillDescription = [NSString stringWithFormat:@"传说中的‘噬日刀’,附加中毒debuff,持续%d回合,每回合掉血%d",skill.debuff.debuffCount,skill.debuff.ATN];
            skill.debuffProbability = 100;
            
        }
            break;
            
        case skill_4:
        {
            // 重剑
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"yunshishu.plist"];
            skill = [Skill spriteWithSpriteFrameName:@"yunshishu_1.png"];
            skill.skillAnimate = [skill Animate:@"yunshishu_" andCount:8 andDelay:1.0/10.0];
            skill.flipX = YES;
//            skill.position = ccp(pt.x + 60, pt.y + 80);
            skill.scale = 0.7f;
            skill.skillIcon = @"skill_104.png";
            skill.skillName = @"重剑无锋";
            skill.skillNameSprite = @"skillh_1032.png";
            skill.debuff = [Debuff deBuff:debuff_4];
            skill.type = skill_4;
            skill.skillDescription = [NSString stringWithFormat:@"传说中的‘重剑无锋’,有0.3几率附加封印效果debuff,持续%d回合",skill.debuff.debuffCount];
            skill.debuffProbability = 50;
            
        }
            
        default:
            break;
    }
    
    if (skill) {
        skill.lev = 1;
        skill.INT = 1;
//        CCLOG(@"*********************************** %@",skill.skillName);
    }
    
    return skill;
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
