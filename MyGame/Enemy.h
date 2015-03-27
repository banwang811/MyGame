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
    ENEMY_BOSS1 = 10, // boss
    
} ENEMY_TYPE;

typedef enum {
    
    ENEMY_SPEAR_HP = 180,
    ENEMY_SWARD_HP = 200,
    ENEMY_SWARD2_HP = 250,
    ENEMY_BOSS1_HP = 500,
    
} ENEMY_HP;

typedef enum {
    
    ENEMY_STAND = 101,
    ENEMY_RUN = 102,
    ENEMY_ATTACK = 103,
    ENEMY_HURT = 104,
    ENEMY_DEAD = 105,
    
} ENEMY_STATE;

typedef enum {
    ENEMY_DAMAGE_1 = 20,
    ENEMY_DAMAGE_2 = 40,
    ENEMY_DAMAGE_BOSS1 = 100,
} ENEMY_DAMAGE;

@interface Enemy : CCSprite {
    
}

@property(nonatomic,retain) NSMutableArray *debuffArray;

@property(nonatomic,assign) id battleScene;

@property(nonatomic,assign) CGPoint oldPt;

@property(nonatomic,assign) BOOL attacking; // 攻击中

@property(nonatomic,assign) ENEMY_DAMAGE enemyDamage; // 攻击力

@property(nonatomic,assign) int hp; // 血量

@property(nonatomic,assign) ENEMY_STATE state; // 敌人状态

@property(nonatomic,assign) int moveSpeed; // 移动速度
@property(nonatomic,assign) int moveFlash; // 刷新帧数

@property(nonatomic,retain) CCAnimate *standAnimate; // 站立动作
@property(nonatomic,retain) CCAnimate *runAnimate;  // 跑动动作
@property(nonatomic,retain) CCAnimate *hurtAnimate;  // 受伤动作
@property(nonatomic,retain) CCAnimate *attackAnimate; // 攻击动作
@property(nonatomic,retain) CCAnimate *deadAnimate;  // 死亡动作
@property(nonatomic,retain) CCAnimate *escapeAnimate; // 逃跑动作

@property(nonatomic,retain) CCProgressTimer *bloodProgress; // 血条

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
 * 创建敌人血条
 * 敌人刷新点
 */
-(void)createEnemyWithBloodAndPosition;

/**
 * 重置敌人状态
 **/
-(void)ChangeEnemyStateNone;

/**
 *敌人执行站立动作
 **/
-(void)EnemyExcuteStand;

/**
 * 敌人移动
 * 向玩家方向移动
 * @param heroPosition 玩家坐标
 */
-(void)EnemyMoveToHero:(CGPoint)heroPosition;

/**
 *敌人执行受伤动作
 *@param damage 伤害量
 **/
-(void)EnemyExcuteHurt:(float)damage;

/**
 *敌人执行攻击动作
 **/
-(void)EnemyExcuteAttack;

-(void)enemyBack;

-(float)runToHeroTime:(CGPoint)heroGt;

-(float)runToHero:(NSString *)heroGt;

-(void)hurtByHero:(NSString *)blood;

@end
