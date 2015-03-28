//
//  Enemy.m
//  FightNow
//
//  Created by yfzx on 13-9-25.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "SimpleAudioEngine.h"
#import "Sound.h"

float enemySpeed = 350;


@implementation Enemy

@synthesize enemyDamage,hp,state;

@synthesize standAnimate,runAnimate,hurtAnimate,attackAnimate,deadAnimate,escapeAnimate,etype,totalHp;

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
    Enemy *enemy;
    switch (type) {
            // 刀兵
        case ENEMY_SWORD:
        {
            
            // 加载敌人plist
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"Sword1.plist"];
            
            enemy = [Enemy spriteWithSpriteFrameName:@"Sword1Stand1.png"];
            
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
            enemy.etype = ENEMY_SWORD;
            [enemy createEnemyWithBloodAndPosition];
            enemy.hp = ENEMY_SWARD_HP; // hp
            enemy.totalHp = ENEMY_SWARD_HP;
            // 攻击力
            enemy.enemyDamage = ENEMY_DAMAGE_1;
            enemy.debuffArray = [[NSMutableArray alloc] initWithCapacity:1];
            
            CCLOG(@"%d",enemy.etype);
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
            enemy.etype = ENEMY_SPEAR;
            [enemy createEnemyWithBloodAndPosition];
            enemy.hp = ENEMY_SPEAR_HP; // hp
            enemy.totalHp = ENEMY_SPEAR_HP;
            // 攻击力
            enemy.enemyDamage = ENEMY_DAMAGE_2;
            enemy.debuffArray = [[NSMutableArray alloc] initWithCapacity:1];
            
            CCLOG(@"%d",enemy.etype);
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
            enemy.etype = ENEMY_SWORD2;
            [enemy createEnemyWithBloodAndPosition];
            enemy.hp = ENEMY_SWARD2_HP; // hp
            enemy.totalHp = ENEMY_SWARD2_HP;
            // 攻击力
            enemy.enemyDamage = ENEMY_DAMAGE_2;
            enemy.debuffArray = [[NSMutableArray alloc] initWithCapacity:1];
            
            CCLOG(@"%d",enemy.etype);
            return enemy;
            
        }
            break;
            
        case ENEMY_ALXMEN:
        {
            
            // 加载敌人plist
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"Axeman.plist"];
            
            Enemy *enemy = [Enemy spriteWithSpriteFrameName:@"AxemanStand1.png"];
            
            // 站立动作
            enemy.standAnimate = [enemy enemyAnimate:@"AxemanStand" andCount:20 andDelay:1.0f/20.0f];
            // 移动动作
            enemy.runAnimate = [enemy enemyAnimate:@"AxemanRun" andCount:20 andDelay:1.0f/20.0f];
            // 攻击动作
            enemy.attackAnimate = [enemy enemyAnimate:@"AxemanAttack" andCount:26 andDelay:1.0f/26.0f];
            // 死亡动作
            enemy.deadAnimate = [enemy enemyAnimate:@"AxemanDead" andCount:29 andDelay:1.0f/29.0f];
            // 逃跑动作
            enemy.escapeAnimate = [enemy enemyAnimate:@"AxemanRun" andCount:20 andDelay:1.0f/20.0f];
            // 受伤动作
            enemy.hurtAnimate = [enemy enemyAnimate:@"AxemanHurt" andCount:11 andDelay:1.0f/11.0f];
            
            // 刷新点,血条
            enemy.etype = ENEMY_SWORD2;
            [enemy createEnemyWithBloodAndPosition];
            enemy.hp = ENEMY_SWARD2_HP; // hp
            enemy.totalHp = ENEMY_SWARD2_HP;
            // 攻击力
            enemy.enemyDamage = ENEMY_DAMAGE_2;
            enemy.debuffArray = [[NSMutableArray alloc] initWithCapacity:1];
            
            CCLOG(@"%d",enemy.etype);
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
            enemy.etype = ENEMY_BOSS1;
            [enemy createEnemyWithBloodAndPosition];
            enemy.hp = ENEMY_BOSS1_HP; // hp
            enemy.totalHp = ENEMY_BOSS1_HP;
            // 攻击力
            enemy.enemyDamage = ENEMY_DAMAGE_BOSS1;
            // debuff次数
            enemy.debuffArray = [[NSMutableArray alloc] initWithCapacity:1];
            
            CCLOG(@"%d",enemy.etype);
            return enemy;
            
        }
            break;
            
        default:
            break;
    }
    return nil;
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
 */
-(void)createEnemyWithBloodAndPosition{
    
    // 随机刷出敌人的坐标
//    self.position=ccp(screenSize.width + 50.0f,CCRANDOM_0_1()*(screenSize.height - 180.0f) + 50.0f);
    // 添加血条背景
    CCSprite *bloodBG = [CCSprite spriteWithFile:@"enemygray.jpg"];
    CCLOG(@"********************************  %d",self.etype);
    if (self.etype < ENEMY_BOSS1) {
        bloodBG.position = ccp(self.contentSize.width * 0.5f, self.boundingBox.size.height * 0.5 + 40);
    } else {
        bloodBG.position = ccp(self.contentSize.width * 0.5f, self.boundingBox.size.height * 0.5 + 60);
    }
    bloodBG.scaleY = 1.5f;
    
    // 添加血条
    self.bloodProgress=[CCProgressTimer progressWithFile:@"enemyred.jpg"];
    self.bloodProgress.position=bloodBG.position;
    self.bloodProgress.percentage =99; //当前进度
    self.bloodProgress.type=kCCProgressTimerTypeHorizontalBarLR;//进度条的显示样式
    self.bloodProgress.percentage+=1;
    self.bloodProgress.scaleY = 1.5f;
    
    [self addChild:bloodBG z:0 tag:88];
    [self addChild:self.bloodProgress z:0 tag:99];
}

-(void)removeBlood{
    [self removeChild:[self getChildByTag:88] cleanup:YES];
    [self removeChild:[self getChildByTag:99] cleanup:YES];
}


/**
 * 敌人返回
 */
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
    if (self.battleScene) {
        [(BattleScene *)self.battleScene enemyAttackOver];
    }

    
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
    self.bloodProgress.percentage = (float)self.hp/self.totalHp * 100; // 血量减少
    
    CCCallFunc *call = [CCCallFunc actionWithTarget:self selector:@selector(enemyHurtOver)];
    // 还没挂
    if (self.hp > 0) {
        [self runAction:[CCSequence actions:self.hurtAnimate,call, nil]];
        [Sound playSound:@"Blood2.mp3"];
    } else {
        // 挂了
        self.state = ENEMY_DEAD;
        CCCallFunc *ff = [CCCallFunc actionWithTarget:self selector:@selector(removeEnemy)];
        [self runAction:[CCSequence actions:self.deadAnimate,ff,call, nil]];
        [Sound playSound:@"maleDead1.mp3"];
    }
}

-(void)enemyHurtOver{
    // 通知战斗界面,敌人已经躺了
    if (self.battleScene) {
        [(BattleScene *)self.battleScene enemyHurtOrDead];
    }

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
