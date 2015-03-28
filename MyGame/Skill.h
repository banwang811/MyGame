//
//  Skill.h
//  FirstGame
//
//  Created by yfzx on 13-10-25.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Debuff.h"

typedef enum {
    skill_1 = 1, // 闪电
    skill_2 = 2, // 火凤
    skill_3 = 3, // 移形换影
    skill_4 = 4, // 落石术
} skill_type;

@interface Skill : CCSprite {
    
}
// 技能类型
@property(nonatomic,assign) skill_type type;
// 技能等级
@property(nonatomic,assign) int lev;
// 技能基础伤害
@property(nonatomic,assign) int INT;
// 技能图标
@property(nonatomic,retain) NSString *skillIcon;
// 技能动画效果
@property(nonatomic,retain) CCAnimate *skillAnimate;
// 技能名称
@property(nonatomic,retain) NSString *skillName;
// 技能描述
@property(nonatomic,retain) NSString *skillDescription;
// 技能名称sprite
@property(nonatomic,retain) NSString *skillNameSprite;
// 技能带的debuff
@property(nonatomic,retain) Debuff *debuff;
// debuff技能命中几率
@property(nonatomic,assign) float debuffProbability;

// 初始化
+(Skill *)skillWithType:(skill_type)type;

// 设置技能坐标
-(void)setSkillPt:(CGPoint)pt;

-(CCAnimate *)Animate:(NSString *)fileName andCount:(int)count andDelay:(float)delay;

@end
