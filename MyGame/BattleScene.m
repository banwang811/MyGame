//
//  BattleScene.m
//  FirstGame
//
//  Created by yfzx on 13-10-24.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "BattleScene.h"
#import "Skill.h"
#import "Debuff.h"

int timess = 30;

BOOL heroAttackOver = NO; // 玩家是否攻击完毕标识
BOOL enemyHurtOver = NO;  // 敌人是否受伤完毕

int  enemyAttackCount = 0; // 敌人攻击次数计数器
int  heroHurtCount = 0;

BOOL WIN = NO; // 胜利标识
BOOL LOSE = NO; // 失败标识

#define attackDamage @"10000"

NSMutableArray *lineArray;
NSArray *ptArray;

@implementation BattleScene

@synthesize hero,enemyArray;

-(void)onEnter{
    [super onEnter];
    
    heroAttackOver = NO;
    enemyHurtOver = NO;
    
    enemyAttackCount = 0;
    heroHurtCount = 0;
    
    WIN = NO;
    LOSE = NO;
    
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BattleScene *layer = [BattleScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if((self=[super init])) {
        if (1) {
            lineArray = [NSMutableArray array];
            ptArray = [NSArray arrayWithObjects:NSStringFromCGPoint(ccp(80, 80)),
                       NSStringFromCGPoint(ccp(80, 160)),
                       NSStringFromCGPoint(ccp(80, 240)), nil];
            [lineArray addObject:ptArray];
            
            ptArray = [NSArray arrayWithObjects:NSStringFromCGPoint(ccp(80, 80)),
                       NSStringFromCGPoint(ccp(80, 240)), nil];
            [lineArray addObject:ptArray];
            
            ptArray = [NSArray arrayWithObjects:NSStringFromCGPoint(ccp(80, 160)),
                       nil];
            [lineArray addObject:ptArray];
            
            ptArray = [NSArray arrayWithObjects:NSStringFromCGPoint(ccp(80, 160)),
                       nil];
            [lineArray addObject:ptArray];
        }
        [self createScene];
//        [self test];
	}
	return self;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    CCLOG(@"战斗场景已经释放了。。。。。");
	[super dealloc];
}

#pragma -
#pragma skillAnimate
-(void)skill:(Enemy *)enemy{
    int x = CCRANDOM_0_1()*3 +1;
    Skill *skill = [Skill skillWithType:x andPt:enemy.position];
    
    CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(removeIt)];
    [skill runAction:[CCSequence actions:skill.skillAnimate,func, nil]];
    [self addChild:skill z:50 tag:123];
    
    int i = CCRANDOM_0_1() * 100;
    if (i > 0) {
        CCLOG(@"debuff.....");
        [self performSelector:@selector(debuff:) withObject:enemy afterDelay:1];
    }
}

-(void)removeIt{
    [self removeChild:[self getChildByTag:123] cleanup:YES];
}

#pragma -
#pragma buff/debuff Animate
-(void)debuff:(CCNode *)node{
    if ([node isKindOfClass:[Enemy class]]) {
        Enemy *enemy = (Enemy *)node;
        int x = CCRANDOM_0_1()*2+1;
        Debuff *debuff = [Debuff deBuff:x andPt:node.position];
        [debuff runAction:debuff.debuffAnimate];
        [node addChild:debuff];
        [enemy.debuffArray addObject:debuff];
    }
    
}

#pragma -
#pragma logicMethod
-(void)createScene{
    
    CCSprite *bg = [CCSprite spriteWithFile:@"41.png"];
    bg.position = ccp(0, 0);
    bg.anchorPoint = ccp(0, 0);
    [self addChild:bg z:-1];
    
    self.enemyArray = [[NSMutableArray alloc] initWithCapacity:1];
    self.hero = [Hero Hero:HERO_1];
    hero.position = ccp(screenSize.width - 100, screenSize.height * 0.5f);
    hero.flipX = YES;
    hero.startPt = hero.position;
    [hero HeroExcuteStand];
    [self addChild:hero z:1];
    hero.battleScene = self;
    // 创建敌人
    [self createEnemyLine];
    // 触摸是否有效
    [self beforeFight];
}

-(void)beforeFight{
    CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 1)];
    layer.opacity = 160.0f;
    [self addChild:layer z:2 tag:123];
    
    CCSprite *showFight = [CCSprite spriteWithFile:@"fight2.png"];
    showFight.scale = 0.1f;
    showFight.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.6f);
    [self addChild:showFight z:3 tag:124];
    CCScaleTo *to = [CCScaleTo actionWithDuration:1 scale:1.2];
    CCFadeOut *fade = [CCFadeOut actionWithDuration:1.2];
    CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(fight)];
    
    [showFight runAction:[CCSequence actions:to,fade,func, nil]];
    
}

-(void)fight{
    [self removeChild:[self getChildByTag:123] cleanup:YES];
    [self showMenuAndComputer];
}

-(void)showMenuAndComputer{
    self.isTouchEnabled = YES;
    CCLabelBMFont  *label = (CCLabelBMFont  *)[self getChildByTag:1200];
    if (nil == label) {
        label =[CCLabelBMFont labelWithString:@""  fntFile:@"myfont1.fnt"];
        label.scale = 0.8f;
        label.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.85f);
        [self addChild:label z:1 tag:1200];
    }
    label.visible = YES;
    [label setString:@"30"];
    [self schedule:@selector(timeComputer) interval:1];
}

-(void)timeComputer{
    
    self.isTouchEnabled = YES;
    timess -- ;
    CCLabelBMFont  *label = (CCLabelBMFont  *)[self getChildByTag:1200];
    if (nil == label) {
        label =[CCLabelBMFont labelWithString:@""  fntFile:@"myfont1.fnt"];
        label.scale = 0.8f;
        label.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.85f);
        [self addChild:label z:1 tag:1200];
    }
    label.visible = YES;
    [label setString:[NSString stringWithFormat:@"%d",timess]];
    
    if (timess <= 0) {
        // 计时器还原,自动攻击
        [self timeComputerClean];
        [self heroAttack:0];
    }
    
}

// 计时器还原
-(void)timeComputerClean{
    timess = 30;
    CCLabelBMFont  *label = (CCLabelBMFont  *)[self getChildByTag:1200];
    if (label) {
        label.visible = NO;
    }
    [self unschedule:@selector(timeComputer)];
}

-(void)createEnemyLine{
    if (lineArray) {
        int rad = CCRANDOM_0_1()*([lineArray count] -1);
        NSArray *array = [lineArray objectAtIndex:rad];
        ENEMY_TYPE etype = ENEMY_SWORD;
        switch ([array count]) {
            case 1:
            {
                etype = ENEMY_BOSS1;
            }
                break;
                
            case 2:
            {
                etype = ENEMY_SWORD;
            }
                break;
                
            default:{
                etype = ENEMY_SPEAR;
            }
                break;
        }
        
        for (int i=0; i<[array count]; i++) {
            NSString *s = [array objectAtIndex:i];
            CGPoint pt = CGPointFromString(s);
            
            Enemy *enemy = [Enemy enemyWithType:etype];
            enemy.position = pt;
            enemy.oldPt = enemy.position;
            enemy.flipX = YES;
            [enemy EnemyExcuteStand];
            [self addChild:enemy z:1];
            [self.enemyArray addObject:enemy];
            enemy.battleScene = self;
            
        }
        
    }
}

#pragma -
#pragma 战斗回合制开始,一般为敌人攻击结束后,或者刚开始进入战斗
// 可以在这里重置buff/debuff效果
-(void)Ready{
    [self showMenuAndComputer];
    self.isTouchEnabled = YES;
    // 每回合敌人重置debuff/buff
    for (Enemy *enemy in self.enemyArray) {
        NSMutableArray *deleteArray = [NSMutableArray array];
        for (Debuff *de in enemy.debuffArray) {
            if (de.debuffCount <= 0) {
                [deleteArray addObject:de];
            }
            de.debuffCount -- ;
        }
        
        for (Debuff *de in deleteArray) {
            [enemy removeChild:de cleanup:YES];
        }
    }
    
    // 每回合重置玩家debuff/buff
    
}

#pragma -
#pragma 玩家攻击逻辑方法
/**
 * 准备攻击
 */
-(void)heroAttack:(int)selected{
    [self timeComputerClean];
    self.isTouchEnabled = NO; // 锁住触屏
    Enemy *enemy = [self.enemyArray objectAtIndex:selected];
    float dur = [hero runToEnemy:enemy.position];
    [self performSelector:@selector(heroAttacking:) withObject:enemy afterDelay:dur];
    
    // 显示技能名称
    CCSprite *showSkill = [CCSprite spriteWithFile:@"skillh_121.png"];
    showSkill.scale = 0.1f;
    showSkill.position = ccp(hero.position.x - 100, hero.position.y + 80);
    [self addChild:showSkill z:200 tag:1024];
    CCScaleTo *scaleto = [CCScaleTo actionWithDuration:0.6 scale:0.3];
    CCFadeOut *fade = [CCFadeOut actionWithDuration:0.5];
    CCMoveTo *to = [CCMoveTo actionWithDuration:0.5 position:ccp(showSkill.position.x + 200, showSkill.position.y)];
    
    CCCallFunc *gb = [CCCallFunc actionWithTarget:self selector:@selector(bye)];
    
    [showSkill runAction:[CCSequence actions:scaleto,[CCSpawn actions:fade,to, nil],gb, nil]];
}

/**
 * 攻击中
 */
-(void)heroAttacking:(Enemy *)enemy{
//    Enemy *enemy = [self.enemyArray objectAtIndex:0];
    int rad = CCRANDOM_0_1() * ([self.hero.attackAnimates count] -1);
    float attackDur = [(CCAnimate *)[hero.attackAnimates objectAtIndex:rad] duration];
    [hero runAction:[hero.attackAnimates objectAtIndex:rad]];
    // 攻击开始后0.2秒敌人执行受伤动作,这样效果比较好,不然就是攻击完了,才执行受伤动作。
    [enemy performSelector:@selector(hurtByHero:) withObject:@"10000" afterDelay:attackDur - 0.2];
    [self performSelector:@selector(skill:) withObject:enemy afterDelay:attackDur - 0.2];
    // 攻击完后,玩家就跑回原位
    [hero performSelector:@selector(runBack) withObject:nil afterDelay:attackDur + 0.5];
    
    
    
}

-(void)bye{
    [self removeChild:[self getChildByTag:1024] cleanup:YES];
}

#pragma -
#pragma 敌人攻击逻辑方法
/**
 * 准备攻击
 */
-(void)enemyAttack{
    self.isTouchEnabled = NO; // 锁住触屏
//    Enemy *enemy = [self.enemyArray objectAtIndex:0];
    float per = 0;
    for (Enemy *enemy in self.enemyArray) {
        
        float dur = [enemy runToHeroTime:hero.position];
        [enemy performSelector:@selector(runToHero:) withObject:NSStringFromCGPoint(hero.position) afterDelay:per];
        [self performSelector:@selector(enemyAttacking:) withObject:enemy afterDelay:dur + per];
        per += 4;

    }
    
}

/**
 * 攻击中
 */
-(void)enemyAttacking:(Enemy *)enemy{
//    Enemy *enemy = [self.enemyArray objectAtIndex:0];
    float attackDur = enemy.attackAnimate.duration;
    [enemy runAction:enemy.attackAnimate];
    // 攻击开始后0.2秒敌人执行受伤动作,这样效果比较好,不然就是攻击完了,才执行受伤动作。
    [hero performSelector:@selector(hurtByEnemy:) withObject:@"1" afterDelay:attackDur - 0.2];
    // 攻击完后,玩家就跑回原位
    [enemy performSelector:@selector(runBack) withObject:nil afterDelay:attackDur + 0.5];
}

#pragma -
#pragma 玩家攻击,敌人受伤,判断是否胜利
/**
 * 玩家攻击完毕
 */
-(void)heroAttackOver{
    // 玩家攻击完毕
    // 可以判断敌人是不是都死光,如果死光了就显示胜利
    heroAttackOver = YES;
    if (enemyHurtOver && heroAttackOver) {
        enemyHurtOver = NO;
        heroAttackOver = NO;
        CCLOG(@"玩家攻击结束了,判断是否胜利");
        [self judgeWin];
    }
}

/**
 * 敌人受伤/死亡动作
 */
-(void)enemyHurtOrDead{
    CCLOG(@"敌人受伤/死亡动作执行完毕...");
    enemyHurtOver = YES;
    if (enemyHurtOver && heroAttackOver) {
        enemyHurtOver = NO;
        heroAttackOver = NO;
        CCLOG(@"敌人受伤结束了,判断是否胜利");
        [self judgeWin];
    }
}

/**
 * 判断是否胜利
 */
-(void)judgeWin{
    NSMutableArray *deleteArr = [NSMutableArray array];
    for (Enemy *e in self.enemyArray) {
        if (ENEMY_DEAD == e.state) {
            [deleteArr addObject:e];
        }
    }
    for (Enemy *de in deleteArr) {
        [self.enemyArray removeObject:de];
    }
    // 敌人数组为空即表示胜利，否则就让敌人开始攻击
    if ([self.enemyArray count] > 0) {
        [self enemyAttack];
    } else {
        [self win];
    }
}

#pragma -
#pragma 敌人攻击,玩家受伤
/**
 * 敌人攻击完毕
 */
-(void)enemyAttackOver{
    CCLOG(@"敌人攻击完毕...");
    // 敌人攻击计数+1
    enemyAttackCount ++;
    CCLOG(@"enemyAttackCount =  %d",enemyAttackCount);
    [self judgeLose];
}

/**
 * 玩家受伤/死亡动作完毕
 */
-(void)heroHurtOrDead{
    CCLOG(@"玩家受伤/死亡动作执行完毕...");
    // 玩家被攻击计数+1
    heroHurtCount ++;
    CCLOG(@"heroHurtCount =  %d",heroHurtCount);
    [self judgeLose];
}

/**
 * 判断敌人是否攻击完毕,是否失败
 */
-(void)judgeLose{
    if (hero.hpNow <= 0) {
        // 英雄都挂了。显示失败
        [self lose];
        return;
    }
    if ((heroHurtCount == enemyAttackCount) &&
        (enemyAttackCount >= [self.enemyArray count])) {
        heroHurtCount = 0;
        enemyAttackCount = 0;
        // 继续回合
        [self Ready];
        
    }
}



#pragma -
#pragma 战斗结束了 胜利/失败
// 成功
-(void)win{
    if (WIN) {
        return;
    }
    [self.hero runAction:[CCRepeat actionWithAction:self.hero.winAnimate times:3]];
    WIN = YES;
    CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 1)];
    layer.opacity = 100.0f;
    [self addChild:layer z:100];
    
    CCSprite *win1 = [CCSprite spriteWithFile:@"win1.png"];
    win1.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    [self addChild:win1 z:101];
    win1.scale = 0.1f;
    CCMoveTo *to1 = [CCMoveTo actionWithDuration:0.2 position:ccp(screenSize.width * 0.5 - 80, screenSize.height * 0.8)];
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.2 scale:1];
    CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(win1)];
    [win1 runAction:[CCSequence actions:[CCSpawn actions:scale,to1, nil],func, nil]];
}

-(void)win1{
    CCSprite *win2 = [CCSprite spriteWithFile:@"win2.png"];
    win2.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    [self addChild:win2 z:101];
    win2.scale = 0.1f;
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.2 scale:1];
    CCMoveTo *to2 = [CCMoveTo actionWithDuration:0.2 position:ccp(screenSize.width * 0.5 + 50, screenSize.height * 0.8)];
    CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(win2)];
    [win2 runAction:[CCSequence actions:[CCSpawn actions:scale,to2, nil],func, nil]];
}

-(void)win2{
    CCSprite *win3 = [CCSprite spriteWithFile:@"win3.png"];
    win3.rotation = 10;
    win3.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    [self addChild:win3 z:101];
    win3.scale = 0.1f;
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.2 scale:1];
    CCMoveTo *to3 = [CCMoveTo actionWithDuration:0.2 position:ccp(screenSize.width * 0.5 + 140, screenSize.height * 0.8)];
    [win3 runAction:[CCSpawn actions:scale,to3, nil]];
    [self performSelector:@selector(backToScene) withObject:nil afterDelay:2];
    
}

// 失败
-(void)lose{
    if (LOSE) {
        return;
    }
    LOSE = YES;
    CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 1)];
    layer.opacity = 100.0f;
    [self addChild:layer z:100];
    
    CCSprite *lose = [CCSprite spriteWithFile:@"lose.png"];
    lose.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    [self addChild:lose z:101];
    lose.scale = 0.1f;
    CCMoveTo *to = [CCMoveTo actionWithDuration:0.2 position:ccp(screenSize.width * 0.5 , screenSize.height * 0.8)];
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.2 scale:1];
    
    [lose runAction:[CCSpawn actions:scale,to, nil]];
    
    [self performSelector:@selector(backToScene) withObject:nil afterDelay:2];
}

// 返回上个场景
-(void)backToScene{
    CCLOG(@"退出战斗场景。。。。。。。。。");
    [[CCDirector sharedDirector] popScene];
}

#pragma -
#pragma ccTouch
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch  *touch=[touches anyObject];
    CGPoint   touchLocation = [touch locationInView:touch.view];
    CGPoint  glLocation=[[CCDirector sharedDirector] convertToGL:touchLocation];
    int selected = -1;
    for (int i=0; i<[self.enemyArray count]; i++) {
        Enemy *e = [self.enemyArray objectAtIndex:i];
        if (CGRectContainsPoint(CGRectMake(e.position.x - 30, e.position.y - 30, 60, 60), glLocation)) {
            selected = i;
            break;
        }
    }
    if (-1 != selected) {
        [self heroAttack:selected];
    }
}

@end
