//
//  BattleScene.h
//  FirstGame
//
//  Created by yfzx on 13-10-24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Hero.h"
#import "Enemy.h"


UIKIT_EXTERN NSString *NSStringFromCGPoint(CGPoint point);
UIKIT_EXTERN CGPoint CGPointFromString(NSString *string);
/**
 * 战斗场景
 */
@interface BattleScene : CCLayer {
    
}

@property(nonatomic,retain) Hero *hero;

@property(nonatomic,retain) NSMutableArray *enemyArray;

+(CCScene *) scene;

-(void)createScene;
-(void)beforeFight;

-(void)heroAttackOver;
-(void)enemyHurtOrDead;

-(void)enemyAttackOver;
-(void)heroHurtOrDead;

-(void)judgeWin;
-(void)judgeLose;

-(void)win;
-(void)lose;

// 随机敌人队形
-(void)createEnemyLine;

// 显示计时器
-(void)showMenuAndComputer;
// 计时器还原
-(void)timeComputerClean;

/**
 * 准备攻击
 */
-(void)heroAttack:(int)selected;

@end
