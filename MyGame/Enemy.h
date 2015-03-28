//
//  Enemy.h
//  FightNow
//
//  Created by yfzx on 13-9-25.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BattleScene.h"

UIKIT_EXTERN NSString *NSStringFromCGPoint(CGPoint point);
UIKIT_EXTERN CGPoint CGPointFromString(NSString *string);

typedef enum{
    
    ENEMY_SWORD = 0, // 刀兵
    ENEMY_SPEAR = 1, // 枪兵
    ENEMY_SWORD2 = 2, // 刀兵2
    ENEMY_ALXMEN = 3, 
    ENEMY_BOSS1 = 10, // boss
    
} ENEMY_TYPE;

typedef enum {
    
    ENEMY_SPEAR_HP = 10,
    ENEMY_SWARD_HP = 15,
    ENEMY_SWARD2_HP = 15,
    ENEMY_BOSS1_HP = 20,
    
} ENEMY_HP;

typedef enum {
    
    ENEMY_STAND = 101,
    ENEMY_RUN = 102,
    ENEMY_ATTACK = 103,
    ENEMY_HURT = 104,
    ENEMY_DEAD = 105,
    
} ENEMY_STATE;

typedef enum {
    ENEMY_DAMAGE_1 = 1,
    ENEMY_DAMAGE_2 = 2,
    ENEMY_DAMAGE_BOSS1 = 3,
} ENEMY_DAMAGE;

@interface Enemy : CCSprite {
    
}
@property(nonatomic,assign) id battleScene; // 战斗场景
@property(nonatomic,assign) CGPoint oldPt; // 原来的坐标

@property(nonatomic,assign) int hp; // 血量
@property(nonatomic,retain) CCProgressTimer *bloodProgress; // 血条
@property(nonatomic,assign) ENEMY_DAMAGE enemyDamage; // 攻击力

@property(nonatomic,assign) ENEMY_STATE state; // 敌人状态
@property(nonatomic,retain) NSMutableArray *debuffArray; // debuff组

@property(nonatomic,retain) CCAnimate *standAnimate; // 站立动作
@property(nonatomic,retain) CCAnimate *runAnimate;  // 跑动动作
@property(nonatomic,retain) CCAnimate *hurtAnimate;  // 受伤动作
@property(nonatomic,retain) CCAnimate *attackAnimate; // 攻击动作
@property(nonatomic,retain) CCAnimate *deadAnimate;  // 死亡动作
@property(nonatomic,retain) CCAnimate *escapeAnimate; // 逃跑动作

@property(nonatomic,assign) ENEMY_TYPE etype;
@property(nonatomic,assign) int totalHp;


// 两点距离
-(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end;

/**
 *创建敌人
 *@param type 敌人类型
 */
+(id)enemyWithType:(ENEMY_TYPE)type;

/**
 *创建敌人动作
 *@param fileName 动作图片
 *@param count 动作图片数量
 *@param delay 动作图片速率
 */
-(CCAnimate *)enemyAnimate:(NSString *)fileName andCount:(int)count andDelay:(float)delay;

/**
 *敌人执行站立动作
 **/
-(void)EnemyExcuteStand;

/**
 * 创建敌人血条
 * 敌人刷新点
 */
-(void)createEnemyWithBloodAndPosition;

-(void)removeBlood;

/**
 * 玩家归位,面对敌人
 * 执行站立动作
 */
-(void)backNormal;

-(void)enemyBack;

-(float)runToHeroTime:(CGPoint)heroGt;

-(float)runToHero:(NSString *)heroGt;

-(void)hurtByHero:(NSString *)blood;

@end
