//
//  Hero.m
//  MyGame
//
//  Created by yfzx on 13-10-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Hero.h"
#import "BattleScene.h"
#import "Skill.h"
#import "Sound.h"

float heroSpeed = 350.0f;

@implementation Hero
@synthesize type;
@synthesize lev; // 等级
@synthesize standAnimate; // 站立动作
@synthesize runAnimate;   // 跑动动作
@synthesize jumpAnimate;  // 跳跃动作
@synthesize hurtAnimate;  // 受伤动作
@synthesize winAnimate;   // 胜利动作
@synthesize loseAnimate;  // 失败动作
@synthesize attackAnimates; // 攻击动作数组

@synthesize startPt;
@synthesize battleScene;
@synthesize heroState;

@synthesize skillArray;
@synthesize buffArray;
@synthesize deBuffArray;

@synthesize bloodProgress;

-(void)dealloc{
    
    [lev release];
    [standAnimate release];
    [runAnimate release];
    [jumpAnimate release];
    [hurtAnimate release];
    [winAnimate release];
    [loseAnimate release];
    [attackAnimates release];
    
    [skillArray release];
    [buffArray release];
    [deBuffArray release];
    
    if (bloodProgress) {
        [bloodProgress release];
    }
    
    CCLOG(@"Hero...release");
    
    [super dealloc];
}

+(id)Hero:(HERO_TYPE)heroType{
    // 加载图片plist文件
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    Hero *hero;
    switch (heroType) {
        case HERO_0:
        {
            // 角色 0 电眼哥
            [frameCache addSpriteFramesWithFile:@"JebatSpriteFrame.plist"];
            hero =[Hero spriteWithSpriteFrameName:@"AMOK_JEBAT_stand_1.png"];
            // 站立动作
            hero.standAnimate = [hero Annimate:@"AMOK_JEBAT_stand_" andFrom:1 andCount:18 andDelay:1.0f/18.0f];
            // 攻击动作数组
            NSArray *ar = [NSArray arrayWithObjects:@"11",@"10",@"10",@"26",@"20", nil];
            hero.attackAnimates = [hero Annimates:@"AMOK_JEBAT_attack" andFrom:1 andCount:ar andDelay:0.0f];
            // 跑动动作
            hero.runAnimate = [hero Annimate:@"AMOK_JEBAT_run_" andFrom:1 andCount:18 andDelay:0.6f/20.0f];
            // 跳跃动作
            hero.jumpAnimate = [hero Annimate:@"AMOK_JEBAT_jump_" andFrom:1 andCount:18 andDelay:1.0f/18.0f];
            // 受伤动作
            hero.hurtAnimate = [hero Annimate:@"AMOK_JEBAT_hurt_" andFrom:1 andCount:8 andDelay:1.0f/18.0f];
            // 胜利 (暂时用这个吧)
            hero.winAnimate = [hero Annimate:@"AMOK_JEBAT_autojump_" andFrom:1 andCount:15 andDelay:1.0f/15.0f];
            // 死亡动作
            hero.loseAnimate = [hero Annimate:@"AMOK_JEBAT_die_" andFrom:1 andCount:13 andDelay:2.0f/13.0f];
            hero.type = HERO_0;
            
        }
            break;
            
        case HERO_1:
        {
            // 角色 1 最帅的那个刀客,有木有
            [frameCache addSpriteFramesWithFile:@"AmokSpriteFrame.plist"];
            hero =[Hero spriteWithSpriteFrameName:@"JEBAT_idle_1.png"];
            // 站立
            hero.standAnimate = [hero Annimate:@"JEBAT_idle_" andFrom:1 andCount:14 andDelay:1.0f/14.0f];
            // 攻击动作数组
            NSArray *ar = [NSArray arrayWithObjects:@"11",@"19",@"14",@"14",@"27", nil];
            hero.attackAnimates = [hero Annimates:@"JEBAT_attack" andFrom:1 andCount:ar andDelay:0];
            // 跑动动作
            hero.runAnimate = [hero Annimate:@"JEBAT_run_" andFrom:1 andCount:16 andDelay:0.6f/20.0f];
            // 跳跃动作
            hero.jumpAnimate = [hero Annimate:@"JEBAT_jump_" andFrom:1 andCount:21 andDelay:1.0f/21.0f];
            // 受伤动作
            hero.hurtAnimate = [hero Annimate:@"JEBAT_hurt_" andFrom:1 andCount:11 andDelay:1.0f/11.0f];
            // 胜利动作
            [frameCache addSpriteFramesWithFile:@"AmokSpriteFrame1.plist"];
            hero.winAnimate = [hero Annimate:@"JEBAT_win_" andFrom:1 andCount:24 andDelay:1.0f/24.0f];
            // 死亡动作
            hero.loseAnimate = [hero Annimate:@"JEBAT_die_" andFrom:1 andCount:12 andDelay:2.0f/12.0f];
            hero.type = HERO_1;
            
        }
            break;
            
        case HERO_2:
        {
            // 角色 2 唯一的女人
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"TejaSpriteFrame.plist"];
            hero =[Hero spriteWithSpriteFrameName:@"TejaRun1.png"];
            
            // 站立
            hero.standAnimate = [hero Annimate:@"TejaIdle" andFrom:0 andCount:13 andDelay:1.0f/13.0f];
            // 攻击动作数组
            NSArray *ar = [NSArray arrayWithObjects:@"11",@"9",@"11",@"21",@"21", nil];
            hero.attackAnimates = [hero Annimates2:@"TejaAttack" andFrom:0 andCount:ar andDelay:0];
            // 跑动动作
            hero.runAnimate = [hero Annimate:@"TejaRun" andFrom:1 andCount:16 andDelay:0.6f/20.0f];
            // 跳跃动作
            hero.jumpAnimate = [hero Annimate:@"TejaJump" andFrom:0 andCount:21 andDelay:1.0f/21.0f];
            // 受伤动作
            hero.hurtAnimate = [hero Annimate:@"TejaHurt" andFrom:0 andCount:13 andDelay:1.0f/13.0f];
            // 胜利动作 (暂时使用该动作)
            hero.winAnimate = [hero Annimate:@"TejaAutojump" andFrom:0 andCount:23 andDelay:1.0f/23.0f];
            // 死亡动作
            hero.loseAnimate = [hero Annimate:@"TejaDead" andFrom:0 andCount:17 andDelay:2.0f/17.0f];
            hero.type = HERO_2;
        }
            break;
            
            // 默认
        default:
            break;
    }
    if (hero) {
        hero.lev = [[Lev alloc] init];
        hero.lev.level = 1;
        hero.lev.ATN = 500;
        hero.lev.DEF = 5;
        hero.lev.INT = 500;
        hero.lev.hpNow = 40;
        hero.lev.totalHp = 40;
        hero.lev.nowExp = 0;
        hero.lev.levExp = 10;
        // 技能数组初始化
        hero.skillArray = [[NSMutableArray alloc] initWithCapacity:1];
        Skill *skill1 = [Skill skillWithType:skill_1]; // 闪电
        Skill *skill2 = [Skill skillWithType:skill_2]; // 火凤
        Skill *skill3 = [Skill skillWithType:skill_3]; // 移形换影
        Skill *skill4 = [Skill skillWithType:skill_4]; // 落石术
        
        [hero.skillArray addObject:skill1];
        [hero.skillArray addObject:skill2];
        [hero.skillArray addObject:skill3];
        [hero.skillArray addObject:skill4];
        // debuff数组
        hero.deBuffArray = [[NSMutableArray alloc] initWithCapacity:1];
        
    }
    return hero;
}

-(void)heroWithBloodProcess{
    
    // 随机刷出敌人的坐标
    //    self.position=ccp(screenSize.width + 50.0f,CCRANDOM_0_1()*(screenSize.height - 180.0f) + 50.0f);
    // 添加血条背景
    CCSprite *bloodBG = [CCSprite spriteWithFile:@"enemygray.jpg"];
    bloodBG.position = ccp(self.contentSize.width * 0.5f, self.boundingBox.size.height * 0.5 + 50);
    CCLOG(@"%f",self.boundingBox.size.height);
    bloodBG.scaleY = 2;
    
    // 添加血条
    self.bloodProgress=[CCProgressTimer progressWithFile:@"enemyred.jpg"];
    self.bloodProgress.position=bloodBG.position;
    self.bloodProgress.percentage =99; //当前进度
    self.bloodProgress.type=kCCProgressTimerTypeHorizontalBarLR;//进度条的显示样式
    self.bloodProgress.percentage+=1;
    self.bloodProgress.scaleY = 2;
    
    [self addChild:bloodBG];
    [self addChild:self.bloodProgress];
}

// 返回动作
-(id)Annimate:(NSString *)fileName andFrom:(int)from andCount:(int)count andDelay:(float)delay{
    NSMutableArray *runArray = [NSMutableArray array];
    for (int i=from; i<=count; i++) {
        NSString *runKey = [NSString stringWithFormat:@"%@%d.png",fileName,i];
        //        CCLOG(@"%@",runKey);
        CCSpriteFrame *runFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:runKey];
        [runArray addObject:runFrame];
    }
    CCAnimation* headAnimation = [CCAnimation animationWithFrames:runArray delay:delay];
    [runArray removeAllObjects];
    id animate = [CCAnimate actionWithAnimation:headAnimation];
    return animate;
}

// 返回动作数组1 _
-(NSMutableArray *)Annimates:(NSString *)fileName andFrom:(int)from andCount:(NSArray *)total andDelay:(float)delay{
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    int x = from;
    for (int i=0;i<total.count;i++) {
        int count = [[total objectAtIndex:i] intValue];
        NSString *name = [NSString stringWithFormat:@"%@%d_",fileName,x];
        //        CCLOG(@"%@",name);
        x++;
        CCAnimation *a = (CCAnimation *)[self Annimate:name andFrom:from andCount:count andDelay:0.5f/count];
        [array addObject:a];
    }
    return array;
}

// 返回动作数组2 -
-(NSMutableArray *)Annimates2:(NSString *)fileName andFrom:(int)from andCount:(NSArray *)total andDelay:(float)delay{
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    int x = from;
    for (int i=0;i<total.count;i++) {
        int count = [[total objectAtIndex:i] intValue];
        NSString *name = [NSString stringWithFormat:@"%@%d-",fileName,x];
        //        CCLOG(@"%@",name);
        x++;
        CCAnimation *a = (CCAnimation *)[self Annimate:name andFrom:from andCount:count andDelay:0.5f/count];
        [array addObject:a];
    }
    return array;
}

// 角色执行站立动作
-(void)HeroExcuteStand{
    //    CCLOG(@"standAnimate");
    self.heroState = HeroState_STATENONE;
    // 停止所有动作,然后执行站立动作
    [self stopAllActions];
    [self runAction:[CCRepeatForever actionWithAction:self.standAnimate]];
}

// 执行完动作后就还原状态
-(void)ChangeHeroStateNone{
    // 执行完动作后就还原状态
    [self HeroExcuteStand];
}

// 角色执行跑动动作
-(void)HeroExcuteRun{
    // 其他动作在执行时,禁止跑动
    if (self.heroState == HeroState_STATENONE) {
        self.heroState = HeroState_RUNNING;
//        CCCallFuncN* re=[CCCallFuncN actionWithTarget:self selector:@selector(ChangeHeroStateNone)];
//        [self runAction:[CCSequence actions:self.runAnimate,re, nil]];
        [self runAction:[CCRepeatForever actionWithAction:self.runAnimate]];
    }
    
}

#pragma -
#pragma logicMethod
/**
 * 玩家归位,面对敌人
 * 执行站立动作
 */
-(void)backNormal{
    self.flipX = YES;
    [self stopAllActions];
    [self runAction:[CCRepeatForever actionWithAction:self.standAnimate]];
    // 通知战斗界面,玩家已经攻击完毕
    if (self.battleScene) {
        [(BattleScene *)self.battleScene heroAttackOver];
    }

}

/**
 * 跑向敌人位置
 * 并返回本次动作消耗的时间
 */
-(float)runToEnemy:(CGPoint)enemyPt{
    float distance = [self distanceFromPointX:self.position distanceToPointY:enemyPt];
    float dur = distance / heroSpeed;
    int repeat = dur / self.runAnimate.duration + 0.5;
    repeat = repeat == 0 ? 1:repeat;
    CCMoveTo *to = [CCMoveTo actionWithDuration:dur position:ccp(enemyPt.x + 60, enemyPt.y)];
    [self runAction:[CCSpawn actions:to,[CCRepeat actionWithAction:self.runAnimate times:repeat], nil]];
    return dur;
}

/**
 * 玩家跑回原位（背对）
 * 面对敌人,执行站立动作
 */
-(void)runBack{
    [self stopAllActions];
    self.flipX = NO; // 背对敌人
    float distance = [self distanceFromPointX:self.position distanceToPointY:self.startPt];
    float dur = distance / heroSpeed;
    int repeat = dur / self.runAnimate.duration + 0.5;
    repeat = repeat == 0 ? 1:repeat;
    CCMoveTo *to = [CCMoveTo actionWithDuration:dur position:self.startPt];
    // 面对敌人,并执行站立动作
    CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(backNormal)];
    [self runAction:[CCSequence actions:[CCSpawn actions:to,[CCRepeat actionWithAction:self.runAnimate times:repeat], nil],func, nil]];
}

/**
 * 被玩家攻击
 * @param blood 掉血量
 */
-(void)hurtByEnemy:(NSString *)blood{
    int dg = [blood floatValue];
    self.lev.hpNow -= dg; // 血量减少
    
    if (self.bloodProgress) {
        self.bloodProgress.percentage = (float)self.lev.hpNow/self.lev.totalHp * 100; // 血量减少
    }
    
    // 还没挂
    if (self.lev.hpNow > 0) {
        CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(heroHurtOrDead)];
        [self runAction:[CCSequence actions:self.hurtAnimate,func, nil]];
        [Sound playSound:@"JebatHurt.mp3"];
    } else  {
        // 挂了
        [self performSelector:@selector(heroHurtOrDead) withObject:nil afterDelay:1.9];
        [self stopAllActions];
        self.heroState = HeroState_LOSE;
        [self runAction:self.loseAnimate];
        [Sound playSound:@"JebatDie.mp3"];
    }
}

-(void)heroHurtOrDead{
    // 通知战斗界面,玩家已经躺了
    if (self.lev.hpNow <= 0) {
        [self pauseSchedulerAndActions];
    }
    if (self.battleScene) {
        [(BattleScene *)self.battleScene heroHurtOrDead];
    }
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
