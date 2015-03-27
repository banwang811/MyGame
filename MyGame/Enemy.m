//
//  Enemy.m
//  FightNow
//
//  Created by yfzx on 13-9-25.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "SimpleAudioEngine.h"

float enemySpeed = 350;


@implementation Enemy

@synthesize attacking;

@synthesize enemyDamage,hp,state;

@synthesize moveSpeed,moveFlash;

@synthesize standAnimate,runAnimate,hurtAnimate,attackAnimate,deadAnimate,escapeAnimate;

@synthesize bloodProgress;

@synthesize oldPt;

@synthesize battleScene;

@synthesize debuffArray;

-(void)dealloc{
    
    [standAnimate release];
    [runAnimate release];
    [hurtAnimate release];
    [attackAnimate release];
    [deadAnimate release];
    [escapeAnimate release];
    
    [bloodProgress release];
    [debuffArray release];
    
    CCLOG(@"Enemy...release");
    
    [super dealloc];
}

/**
 *创建敌人
 *@param type 敌人类型
 */
+(id)enemyWithType:(ENEMY_TYPE)type{
    
    switch (type) {
            // 刀兵
        case ENEMY_SWORD:
        {
            
            // 加载敌人plist
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"Sword1.plist"];
            
            Enemy *enemy = [Enemy spriteWithSpriteFrameName:@"Sword1Stand1.png"];
            
            // 站立动作
            enemy.standAnimate = [enemy enemyAnimate:@"Sword1Stand" andCount:16 andDelay:1.0f/16.0f];
            // 移动动作
            enemy.runAnimate = [enemy enemyAnimate:@"Sword1Run" andCount:16 andDelay:1.0f/16.0f];
            // 攻击动作
            enemy.attackAnimate = [enemy enemyAnimate:@"Sword1Attack1_" andCount:10 andDelay:1.0f/10.0f];
            // 死亡动作
            enemy.deadAnimate = [enemy enemyAnimate:@"Sword1Dead" andCount:13 andDelay:1.0f/13.0f];
            // 逃跑动作
            enemy.escapeAnimate = [enemy enemyAnimate:@"Sword1Evade" andCount:8 andDelay:1.0f/8.0f];
            // 受伤动作
            enemy.hurtAnimate = [enemy enemyAnimate:@"Sword1Hurt" andCount:10 andDelay:1.0f/10.0f];
            
            // 刷新点,血条
            [enemy createEnemyWithBloodAndPosition];
            enemy.hp = ENEMY_SWARD_HP; // hp
            
            // 移动速度
            enemy.moveSpeed = CCRANDOM_0_1()*100 + 200;
            enemy.moveFlash = CCRANDOM_0_1()*100;
            
            // 攻击力
            enemy.enemyDamage = ENEMY_DAMAGE_1;
            enemy.debuffArray = [[NSMutableArray alloc] initWithCapacity:1];
            return enemy;
            
        }
            break;
          
            // 枪兵
        case ENEMY_SPEAR:
        {
            
            // 加载敌人plist
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"Spear1.plist"];
            
            Enemy *enemy = [Enemy spriteWithSpriteFrameName:@"Spear1Stand1.png"];
            
            // 站立动作
            enemy.standAnimate = [enemy enemyAnimate:@"Spear1Stand" andCount:11 andDelay:1.0f/11.0f];
            // 移动动作
            enemy.runAnimate = [enemy enemyAnimate:@"Spear1Run" andCount:16 andDelay:1.0f/16.0f];
            // 攻击动作
            enemy.attackAnimate = [enemy enemyAnimate:@"Spear1Attack1_" andCount:14 andDelay:1.0f/14.0f];
            // 死亡动作
            enemy.deadAnimate = [enemy enemyAnimate:@"Spear1Dead" andCount:13 andDelay:1.0f/13.0f];
            // 逃跑动作
            enemy.escapeAnimate = [enemy enemyAnimate:@"Spear1Evade" andCount:11 andDelay:1.0f/13.0f];
            // 受伤动作
            enemy.hurtAnimate = [enemy enemyAnimate:@"Spear1Hurt" andCount:10 andDelay:1.0f/10.0f];
            
            // 刷新点,血条
            [enemy createEnemyWithBloodAndPosition];
            enemy.hp = ENEMY_SPEAR_HP; // hp
            
            // 移动速度
            enemy.moveSpeed = CCRANDOM_0_1()*100 + 200;
            enemy.moveFlash = CCRANDOM_0_1()*100;
            
            // 攻击力
            enemy.enemyDamage = ENEMY_DAMAGE_2;
            enemy.debuffArray = [[NSMutableArray alloc] initWithCapacity:1];
            return enemy;
            
        }
            break;

            // 刀兵
        case ENEMY_SWORD2:
        {
            
            // 加载敌人plist
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"Blader.plist"];
            
            Enemy *enemy = [Enemy spriteWithSpriteFrameName:@"BladerStand1.png"];
            
            // 站立动作
            enemy.standAnimate = [enemy enemyAnimate:@"BladerStand" andCount:20 andDelay:1.0f/20.0f];
            // 移动动作
            enemy.runAnimate = [enemy enemyAnimate:@"BladerRun" andCount:19 andDelay:1.0f/19.0f];
            // 攻击动作
            enemy.attackAnimate = [enemy enemyAnimate:@"BladerAttack" andCount:17 andDelay:1.0f/17.0f];
            // 死亡动作
            enemy.deadAnimate = [enemy enemyAnimate:@"BladerDead" andCount:12 andDelay:1.0f/12.0f];
            // 逃跑动作
            enemy.escapeAnimate = [enemy enemyAnimate:@"BladerRun" andCount:19 andDelay:1.0f/19.0f];
            // 受伤动作
            enemy.hurtAnimate = [enemy enemyAnimate:@"BladerHurt" andCount:8 andDelay:1.0f/8.0f];
            
            // 刷新点,血条
            [enemy createEnemyWithBloodAndPosition];
            enemy.hp = ENEMY_SWARD2_HP; // hp
            
            // 移动速度
            enemy.moveSpeed = CCRANDOM_0_1()*100 + 200;
            enemy.moveFlash = CCRANDOM_0_1()*100;
            
            // 攻击力
            enemy.enemyDamage = ENEMY_DAMAGE_2;
            enemy.debuffArray = [[NSMutableArray alloc] initWithCapacity:1];
            return enemy;
            
        }
            break;
            
            // BOSS1
        case ENEMY_BOSS1:
        {
            
            // 加载敌人plist
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"Boss8.plist"];
            
            Enemy *enemy = [Enemy spriteWithSpriteFrameName:@"Boss8Stand1.png"];
            
            // 站立动作
            enemy.standAnimate = [enemy enemyAnimate:@"Boss8Stand" andCount:16 andDelay:1.0f/16.0f];
            // 移动动作
            enemy.runAnimate = [enemy enemyAnimate:@"Boss8Walk" andCount:16 andDelay:1.0f/16.0f];
            // 攻击动作
            enemy.attackAnimate = [enemy enemyAnimate:@"Boss8Attack1_" andCount:16 andDelay:1.0f/16.0f];
            // 死亡动作
            enemy.deadAnimate = [enemy enemyAnimate:@"Boss8Dead" andCount:9 andDelay:1.0f/9.0f];
            // 逃跑动作
            enemy.escapeAnimate = [enemy enemyAnimate:@"Boss8Walk" andCount:16 andDelay:1.0f/16.0f];
            // 受伤动作
            enemy.hurtAnimate = [enemy enemyAnimate:@"Boss8Hurt" andCount:5 andDelay:1.0f/5.0f];
            
            // 刷新点,血条
            [enemy createEnemyWithBloodAndPosition];
            enemy.hp = ENEMY_BOSS1_HP; // hp
            
            // 移动速度
            enemy.moveSpeed = CCRANDOM_0_1()*50 + 100;
            enemy.moveFlash = CCRANDOM_0_1()*50;
            
            // 攻击力
            enemy.enemyDamage = ENEMY_DAMAGE_BOSS1;
            // debuff次数
            enemy.debuffArray = [[NSMutableArray alloc] initWithCapacity:1];
            
            return enemy;
            
        }
            break;
            
        default:
            break;
    }
    return nil;
}


/**
 *创建敌人动作
 *@param fileName 动作图片
 *@param count 动作图片数量
 *@param delay 动作图片速率
 */
-(CCAnimate *)enemyAnimate:(NSString *)fileName andCount:(int)count andDelay:(float)delay{
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

/**
 * 创建敌人血条
 * 敌人刷新点
 */
-(void)createEnemyWithBloodAndPosition{
    
    // 随机刷出敌人的坐标
    self.position=ccp(screenSize.width + 50.0f,CCRANDOM_0_1()*(screenSize.height - 180.0f) + 50.0f);
    // 添加血条背景
    CCSprite *bloodBG = [CCSprite spriteWithFile:@"enemygray.jpg"];
    bloodBG.position = ccp(self.contentSize.width * 0.5f, self.contentSize.height * 0.6f + 25);
    
    // 添加血条
    self.bloodProgress=[CCProgressTimer progressWithFile:@"enemyred.jpg"];
    self.bloodProgress.position=bloodBG.position;
    self.bloodProgress.percentage =99; //当前进度
    self.bloodProgress.type=kCCProgressTimerTypeHorizontalBarLR;//进度条的显示样式
    self.bloodProgress.percentage+=1;
    
    [self addChild:bloodBG z:hero_zOrder];
    [self addChild:self.bloodProgress z:hero_zOrder];
    
    [self EnemyExcuteStand];
}

#pragma -
#pragma enemyAction
/**
 * 重置敌人状态
 **/
-(void)ChangeEnemyStateNone{
    [self EnemyExcuteStand];
}

/**
 * 敌人执行站立动作
 **/
-(void)EnemyExcuteStand{
    [self stopAllActions];
    self.state = ENEMY_STAND; // 设置状态(站立状态)
    [self runAction:[CCRepeatForever actionWithAction:self.standAnimate]];
    
}

/**
 * 敌人移动
 * 向玩家方向移动
 * @param heroPosition 玩家坐标
 */
-(void)EnemyMoveToHero:(CGPoint)heroPosition{
    if (self != nil) {
        
        self.moveFlash ++ ;
        if (self.moveFlash >= self.moveSpeed) {
            
            // 重置刷新数
            self.moveFlash = 0;
            
            // 更改敌人朝向,一直面对玩家
            // 并同时朝玩家移动
            float x; // x 移动量
            float y; // y 移动量
            
            if (self.position.x > heroPosition.x) {
                self.flipX = NO; // 面向左边
                x = self.position.x - 80.0f;
            } else{                
                self.flipX = YES; // 面向右边
                x = self.position.x + 80.0f;
            }
            
            if (self.position.y > heroPosition.y) {
                y = self.position.y - 10.0f;
            } else {
                y = self.position.y + 10.0f;
            }
            
            // 已经在玩家旁边了,还等什么。。。砍死他
            
            if (fabs(self.position.x - heroPosition.x) <= 80 && fabs(self.position.y - heroPosition.y) <= 20) {
                
                self.state = ENEMY_ATTACK;
                self.attacking = YES;
                
                return;
                
            }
            
            // 设置状态(跑动状态)
            self.state = ENEMY_RUN;
            [self stopAllActions];
            CCMoveTo *place = [CCMoveTo actionWithDuration:1 position:ccp(x, y)];
            // 动作执行完后还原状态
            CCCallFuncN *func = [CCCallFuncN actionWithTarget:self selector:@selector(ChangeEnemyStateNone)];
            CCSequence *seq = [CCSequence actions:[CCSpawn actions:self.runAnimate,place, nil],func,nil];
            [self runAction:seq];
        }
    }
    
}

/**
 *敌人执行攻击动作
 **/
-(void)EnemyExcuteAttack{
    self.state = ENEMY_ATTACK;
    [self stopAllActions];
    CCCallFuncN *func = [CCCallFuncN actionWithTarget:self selector:@selector(ChangeEnemyStateNone)];
    [self runAction:[CCSequence actions:self.attackAnimate,func, nil]];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"SwordHit.mp3"];
}

/**
 *敌人执行受伤动作
 *@param damage 伤害量
 **/
-(void)EnemyExcuteHurt:(float)damage{
    
    if (CCRANDOM_0_1()*10 < 9) {
        self.attacking = NO;
    }
    
    if (self.state == ENEMY_DEAD || self.state == ENEMY_ATTACK) {
        return;
    }
    
    [self stopAllActions];
    self.state = ENEMY_HURT; // 设置状态(受伤状态)
    
    self.hp -= damage;
    self.bloodProgress.percentage = (float)self.hp/ENEMY_SPEAR_HP * 100;
    
    if (self.hp > 0) {
        // 受伤 + 受伤音效
        [[SimpleAudioEngine sharedEngine] playEffect:@"Blood2.mp3"];
        CCCallFuncN *func = [CCCallFuncN actionWithTarget:self selector:@selector(ChangeEnemyStateNone)];
        [self runAction:[CCSequence actions:self.hurtAnimate,func, nil]];
    } else {
        // 死亡 + 受伤音效
        self.state = ENEMY_DEAD;
        [[SimpleAudioEngine sharedEngine] playEffect:@"maleDead1.mp3"];
        CCCallFuncN *func = [CCCallFuncN actionWithTarget:self selector:@selector(removeEnemy)];
        [self runAction:[CCSequence actions:self.deadAnimate,func, nil]];
    }
    
    
}


-(void)enemyBack{
    self.flipX = NO;
    CCMoveTo *to = [CCMoveTo actionWithDuration:1 position:self.oldPt];
    
    int repeat = 1 / self.runAnimate.duration;
    if (repeat == 0) {
        repeat = 1;
    }
    
    CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(backNormal)];
    
    [self runAction:[CCSequence actions:[CCSpawn actions:self.runAnimate,[CCRepeat actionWithAction:self.runAnimate times:repeat],to, nil],func, nil]];
}

/**
 * 保持原来朝向,状态
 */
-(void)backNormal{
    self.flipX = YES;
    [self stopAllActions];
    [self runAction:[CCRepeatForever actionWithAction:self.standAnimate]];
    
    [(BattleScene *)self.battleScene enemyAttackOver];
    
}
-(float)runToHeroTime:(CGPoint)heroGt{
    float distance = [self distanceFromPointX:self.position distanceToPointY:heroGt];
    float dur = distance / enemySpeed;
    return dur;
}

/**
 * 跑向玩家
 * @param heroPt 玩家坐标
 * return 返回跑向玩家的时间
 */
-(float)runToHero:(NSString *)heroGt{
    CGPoint gtt = CGPointFromString(heroGt);
    float distance = [self distanceFromPointX:self.position distanceToPointY:gtt];
    float dur = distance / enemySpeed;
    int repeat = dur / self.runAnimate.duration + 0.5;
    repeat = repeat == 0 ? 1:repeat;
    CCMoveTo *to = [CCMoveTo actionWithDuration:dur position:ccp(gtt.x - 60, gtt.y)];
    [self runAction:[CCSpawn actions:to,[CCRepeat actionWithAction:self.runAnimate times:repeat], nil]];
    return dur;
}

-(void)runBack{
    [self stopAllActions];
    self.flipX = NO; // 背对敌人
    float distance = [self distanceFromPointX:self.position distanceToPointY:self.oldPt];
    float dur = distance / enemySpeed;
    int repeat = dur / self.runAnimate.duration + 0.5;
    repeat = repeat == 0 ? 1:repeat;
    CCMoveTo *to = [CCMoveTo actionWithDuration:dur position:self.oldPt];
    // 面对敌人,并执行站立动作
    CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(backNormal)];
    [self runAction:[CCSequence actions:[CCSpawn actions:to,[CCRepeat actionWithAction:self.runAnimate times:repeat], nil],func, nil]];}

/**
 * 被玩家攻击
 * @param blood 掉血量
 */
-(void)hurtByHero:(NSString *)blood{
    int damage = [blood intValue];
    self.hp -= damage; // 血量减少
    self.bloodProgress.percentage = (float)self.hp/ENEMY_SPEAR_HP * 100; // 血量减少
    
    CCCallFunc *call = [CCCallFunc actionWithTarget:self selector:@selector(enemyHurtOver)];
    // 还没挂
    if (self.hp > 0) {
        [self runAction:[CCSequence actions:self.hurtAnimate,call, nil]];
    } else  {
        // 挂了
        self.state = ENEMY_DEAD;
        CCCallFunc *ff = [CCCallFunc actionWithTarget:self selector:@selector(removeEnemy)];
        [self runAction:[CCSequence actions:self.deadAnimate,ff,call, nil]];
    }
}

-(void)enemyHurtOver{
    // 通知战斗界面,敌人已经躺了
    [(BattleScene *)self.battleScene enemyHurtOrDead];
}

/**
 * 敌人挂了,更改状态,移除
 */
-(void)removeEnemy{
    self.state = ENEMY_DEAD;
    [self stopAllActions];
    [self removeFromParentAndCleanup:YES];
}

/**
 * 计算两点距离
 */
-(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end{
    float distance;
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

@end
