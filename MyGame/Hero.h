//
//  Hero.h
//  MyGame
//
//  Created by yfzx on 13-10-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Lev.h"

// 英雄角色
typedef enum{
    HERO_0 = 0,
    HERO_1 = 1,
    HERO_2 = 2,
} HERO_TYPE;

// 英雄状态
typedef enum{
    HeroState_STATENONE = 0,  // 站立
    HeroState_JUMPING = 1,    // 跳动
    HeroState_RUNNING = 2,    // 跑动
    HeroState_SKILL = 3,      // 技能
    HeroState_HURT = 4,       // 受伤
    HeroState_WIN = 5,        // 胜利
    HeroState_LOSE = 6,       // 失败
    HeroState_ATTACK = 7,     // 攻击
} HeroState;


@interface Hero : CCSprite {
    
}
@property(nonatomic,assign) HERO_TYPE type;
@property(nonatomic,retain) Lev *lev; // 等级

@property(nonatomic,retain) CCAnimate *standAnimate; // 站立动作
@property(nonatomic,retain) CCAnimate *runAnimate;   // 跑动动作
@property(nonatomic,retain) CCAnimate *jumpAnimate;  // 跳跃动作
@property(nonatomic,retain) CCAnimate *hurtAnimate;  // 受伤动作
@property(nonatomic,retain) CCAnimate *winAnimate;   // 胜利动作
@property(nonatomic,retain) CCAnimate *loseAnimate;  // 失败动作
@property(nonatomic,retain) NSMutableArray *attackAnimates; // 攻击动作数组


@property(nonatomic,assign) CGPoint startPt;
@property(nonatomic,assign) id battleScene;
@property(nonatomic,assign) HeroState heroState; // 角色状态
@property(nonatomic,retain) NSMutableArray *skillArray; // 英雄技能组
@property(nonatomic,retain) NSMutableArray *buffArray;  // buff数组
@property(nonatomic,retain) NSMutableArray *deBuffArray;  // debuff数组

@property(nonatomic,retain) CCProgressTimer *bloodProgress; // 血条

// hero初始化
+(id)Hero:(HERO_TYPE)heroType;

// 玩家血条
-(void)heroWithBloodProcess;

// 角色执行站立动作
-(void)HeroExcuteStand;

// 返回动作
-(id)Annimate:(NSString *)fileName andFrom:(int)from andCount:(int)count andDelay:(float)delay;

// 返回动作数组
-(NSMutableArray *)Annimates:(NSString *)fileName andFrom:(int)from andCount:(NSArray *)total andDelay:(float)delay;

// 返回动作数组2
-(NSMutableArray *)Annimates2:(NSString *)fileName andFrom:(int)from andCount:(NSArray *)total andDelay:(float)delay;

// 还原状态
-(void)backNormal;

/**
 * 玩家受伤/死亡动作完毕
 */
-(void)heroHurtOrDead;

// 返回两点距离
-(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end;

// 跑向敌人坐标
-(float)runToEnemy:(CGPoint)enemyPt;

// 受伤
-(void)hurtByEnemy:(NSString *)blood;

// 返回
-(void)runBack;

// 执行完动作后就还原状态
-(void)ChangeHeroStateNone;

// 角色执行跑动动作
-(void)HeroExcuteRun;

@end
