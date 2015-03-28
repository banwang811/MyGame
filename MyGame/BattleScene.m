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
#import "BattleResult.h"
#import "CCRadioMenu.h"
#import "CCMenuItemLabel2.h"
#import "UserData.h"
#import "Sound.h"

int timess = 30;

BOOL heroAttackOver = NO; // 玩家是否攻击完毕标识
BOOL enemyHurtOver = NO;  // 敌人是否受伤完毕

int  enemyAttackCount = 0; // 敌人攻击次数计数器
int  heroHurtCount = 0;

BOOL WIN = NO; // 胜利标识
BOOL LOSE = NO; // 失败标识

int HEROHP = 0;

#define attackDamage @"10000"

int SELECTED_SKILL = -1;

NSMutableArray *lineArray;
NSArray *ptArray;

typedef enum {
    menubg_tag = 78,
    menu_tag = 79,
    blood_tag = 80,
    skill_tag = 81,
    computer_tag = 82,
    skillDetail_tag = 83,
} battle_tag;

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
                       NSStringFromCGPoint(ccp(80, 160)),
                       NSStringFromCGPoint(ccp(80, 240)),
                       NSStringFromCGPoint(ccp(160, 160)), nil];
            [lineArray addObject:ptArray];
            
            ptArray = [NSArray arrayWithObjects:NSStringFromCGPoint(ccp(80, 80)),
                       NSStringFromCGPoint(ccp(80, 240)), nil];
            [lineArray addObject:ptArray];
            
            ptArray = [NSArray arrayWithObjects:NSStringFromCGPoint(ccp(80, 160)),
                       nil];
            [lineArray addObject:ptArray];
            
            
            HEROHP = 0;
        }
        [self createScene];
        
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
    int damage = self.hero.lev.ATN;
    if (-1 != SELECTED_SKILL) {
        // 如果选择的是技能,就显示技能效果
        Skill *skill = [self.hero.skillArray objectAtIndex:SELECTED_SKILL];
        [skill setSkillPt:enemy.position];
        CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(removeIt)];
        [skill runAction:[CCSequence actions:skill.skillAnimate,func, nil]];
        [self addChild:skill z:50 tag:123];
        // 伤害量
        damage = self.hero.lev.INT * skill.INT * 2;
        // 技能打在敌人身上的debuff效果
        // 计算debuff命中几率
        int x = CCRANDOM_0_1() * 100;
        CCLOG(@"命中几率的随机数为 %d , %f",x,skill.debuffProbability);
        if (x <= skill.debuffProbability) {
            [self performSelector:@selector(debuff:) withObject:enemy  afterDelay:1];
        }
    }
    // 敌人执行受伤动作
    [enemy hurtByHero:[NSString stringWithFormat:@"%d",damage]];
    // 敌人掉血动画
    [self showBlood:[NSString stringWithFormat:@"- %d",damage] andPt:enemy.position];
}

#pragma -
#pragma buff/debuff Animate
-(void)debuff:(CCNode *)node{
    // 敌人debuff效果
    if ([node isKindOfClass:[Enemy class]]) {
        if (-1 != SELECTED_SKILL) {
            // 如果选择的是技能,就显示技能效果
            Skill *sk = [self.hero.skillArray objectAtIndex:SELECTED_SKILL];
            Skill *skill = [Skill skillWithType:sk.type];
            Enemy *enemy = (Enemy *)node;
            Debuff *debuff = skill.debuff;
            for (Debuff *ddd in enemy.debuffArray) {
                if (ddd.dtype == debuff.dtype) {
                    CCLOG(@"已经有了这种状态,状态显示不能叠加,debuff回合数+1");
                    ddd.debuffCount ++;
                    return;
                }
            }
            [debuff setDebuffPt:node.position];
            [debuff runAction:debuff.debuffAnimate];
            [node addChild:debuff];
            [enemy.debuffArray addObject:debuff];
            
        }
    }
    
}

-(void)showBlood:(NSString *)blood andPt:(CGPoint)pt{
    CCLabelTTF *lab1 = [CCLabelTTF labelWithString:blood
                                          fontName:@"Verdana-Bold"
                                          fontSize:20];
    lab1.color = ccRED;
    lab1.position = ccp(pt.x, pt.y + 60);
    [self addChild:lab1 z:2000 tag:blood_tag];
    
    CCMoveBy *lto = [CCMoveBy actionWithDuration:0.5 position:ccp(0, 10)];
    [self performSelector:@selector(bye2) withObject:nil afterDelay:1];
    [lab1 runAction:lto];
}

-(void)bye2{
    [self removeChild:[self getChildByTag:blood_tag] cleanup:YES];
}

-(void)removeIt{
    [self removeChild:[self getChildByTag:123] cleanup:YES];
}



#pragma -
#pragma logicMethod
-(void)createScene{
    
    CCSprite *bg = [CCSprite spriteWithFile:@"41.png"];
    bg.position = ccp(0, 0);
    bg.anchorPoint = ccp(0, 0);
    [self addChild:bg z:-1];
    
    self.enemyArray = [[NSMutableArray alloc] initWithCapacity:1];
    [self createHero];
    // 创建敌人
    [self createEnemyLine];
    // 触摸是否有效
    [self beforeFight];
    
    timess = 30;
    heroAttackOver = NO; // 玩家是否攻击完毕标识
    enemyHurtOver = NO;  // 敌人是否受伤完毕
    enemyAttackCount = 0; // 敌人攻击次数计数器
    heroHurtCount = 0;
    WIN = NO; // 胜利标识
    LOSE = NO; // 失败标识
    HEROHP = 0;
    SELECTED_SKILL = -1;
}

-(void)createHero{
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    NSData *Data = [arr objectForKey:@"USERDATA"];
    if (Data) {
        UserData *userData = [NSKeyedUnarchiver unarchiveObjectWithData:Data];
        self.hero = [Hero Hero:userData.heroType];
        self.hero.lev.hpNow = userData.hpNow;
        // 创建玩家血条
        [hero heroWithBloodProcess];
        hero.bloodProgress.percentage = (float)userData.hpNow / hero.lev.totalHp * 100;
    } else {
        self.hero = [Hero Hero:HERO_0];
        // 创建玩家血条
        [hero heroWithBloodProcess];
    }
    
    hero.position = ccp(screenSize.width - 100, screenSize.height * 0.5f);
    hero.flipX = YES;
    hero.startPt = hero.position;
    [hero HeroExcuteStand];
    [self addChild:hero z:1];
    hero.battleScene = self;
}
    
// 进入战斗状态字显示
-(void)beforeFight{
    CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 1)];
    layer.opacity = 100.0f;
    [self addChild:layer z:2 tag:77];
    
    CCSprite *showFight = [CCSprite spriteWithFile:@"fight2.png"];
    showFight.scale = 0.1f;
    showFight.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.6f);
    [self addChild:showFight z:3 tag:88];
    CCScaleTo *to = [CCScaleTo actionWithDuration:1 scale:1.2];
    CCFadeOut *fade = [CCFadeOut actionWithDuration:1.2];
    CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(fight)];
    
    [showFight runAction:[CCSequence actions:to,fade,func, nil]];
    
}
// 进入战斗页面
-(void)fight{
    [self removeChild:[self getChildByTag:77] cleanup:YES];
    [self removeChild:[self getChildByTag:88] cleanup:YES];
    [self showMenuAndComputer];
}

// 显示菜单及读秒
-(void)showMenuAndComputer{
    self.isTouchEnabled = YES;
    CCLabelBMFont  *label = (CCLabelBMFont  *)[self getChildByTag:computer_tag];
    if (nil == label) {
        label =[CCLabelBMFont labelWithString:@""  fntFile:@"myfont1.fnt"];
        label.scale = 0.8f;
        label.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.85f);
        [self addChild:label z:1 tag:computer_tag];
    }
    label.visible = YES;
    [label setString:@"30"];
    [self schedule:@selector(timeComputer) interval:1];
    
    [self createNormalClickMenu];
    
    
}

// 战斗菜单
-(void)createNormalClickMenu{
    SELECTED_SKILL = -1;
    [self removeChild:[self getChildByTag:menu_tag] cleanup:YES];
    [self removeChild:[self getChildByTag:menubg_tag] cleanup:YES];
    [self removeChild:[self getChildByTag:skillDetail_tag] cleanup:YES];
    
    CCLabelTTF *lab1 = [CCLabelTTF labelWithString:@"攻击" fontName:@"STHeitiK-Light" fontSize:20];
    lab1.color = ccBLACK;
    CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:lab1 target:self selector:@selector(attackMenuClick)];
    
    CCLabelTTF *lab2 = [CCLabelTTF labelWithString:@"法术" fontName:@"STHeitiK-Light" fontSize:20];
    lab2.color = ccBLACK;
    CCMenuItemLabel *item2 = [CCMenuItemLabel itemWithLabel:lab2 target:self selector:@selector(magicMeunClick)];
    
    CCLabelTTF *lab3 = [CCLabelTTF labelWithString:@"逃跑" fontName:@"STHeitiK-Light" fontSize:20];
    lab3.color = ccBLACK;
    CCMenuItemLabel *item3 = [CCMenuItemLabel itemWithLabel:lab3 target:self selector:@selector(escape)];
    
    CCRadioMenu *radio = [CCRadioMenu menuWithItems:item1,item2,item3, nil];
    radio.position = ccp(screenSize.width * 0.5, 160);
    [radio alignItemsVerticallyWithPadding:10];
    
    CCSprite *menuBg = [CCSprite spriteWithFile:@"BlockUI.png"];
    menuBg.rotation = 90;
    menuBg.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    menuBg.scale = 0.4f;
    menuBg.scaleX = 0.2f;
    
    [self addChild:menuBg z:999 tag:menubg_tag];
    
    [self addChild:radio z:1000 tag:menu_tag];
    
}

// 攻击按钮
-(void)attackMenuClick{
    [self removeChild:[self getChildByTag:menu_tag] cleanup:YES];
    CCRadioMenu *radio = [CCRadioMenu menuWithItems:nil];
    CCLabelTTF *lab1 = [CCLabelTTF labelWithString:@"返回" fontName:@"STHeitiK-Light" fontSize:20];
    lab1.color = ccBLACK;
    CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:lab1 target:self selector:@selector(itemBackClick)];
    [radio addChild:item1];
    [radio alignItemsVerticallyWithPadding:10];
    [self addChild:radio z:1000 tag:menu_tag];
}

// 法术按钮
-(void)magicMeunClick{
    [self removeChild:[self getChildByTag:menu_tag] cleanup:YES];
    CCRadioMenu *radio = [CCRadioMenu menuWithItems:nil];
    int i = 0;
    for (Skill *skill in self.hero.skillArray) {
        CCLabelTTF *lab = [CCLabelTTF labelWithString:skill.skillName fontName:@"STHeitiK-Light" fontSize:20];
        CCMenuItemLabel2 *item = [CCMenuItemLabel2 itemWithLabel:lab target:self selector:@selector(magicAttack:)];
        lab.color = ccBLACK;
        item.tag = i;
        i++;
        item.skillIcon = skill.skillIcon;
        item.skillName = skill.skillName;
        item.skillDescription = skill.skillDescription;
        [radio addChild:item];
    }
    
    CCLabelTTF *lab1 = [CCLabelTTF labelWithString:@"返回" fontName:@"STHeitiK-Light" fontSize:20];
    lab1.color = ccBLACK;
    CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:lab1 target:self selector:@selector(itemBackClick)];
    [radio addChild:item1];
    
    [radio alignItemsVerticallyWithPadding:10];
    
    [self addChild:radio z:1000 tag:menu_tag];
}

// 技能按钮
-(void)magicAttack:(CCNode *)node{
    CCLOG(@"%d",node.tag);
    
    CCMenuItemLabel2 *item = (CCMenuItemLabel2 *)node;
    [self showSkillDetail:item.skillIcon andName:item.skillName andDesc:item.skillDescription];
    
    SELECTED_SKILL = node.tag;
    [self removeChild:[self getChildByTag:menu_tag] cleanup:YES];
    CCRadioMenu *radio = [CCRadioMenu menuWithItems:nil];
    CCLabelTTF *lab1 = [CCLabelTTF labelWithString:@"返回" fontName:@"STHeitiK-Light" fontSize:20];
    lab1.color = ccBLACK;
    CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:lab1 target:self selector:@selector(itemBackClick)];
    [radio addChild:item1];
    [radio alignItemsVerticallyWithPadding:10];
    [self addChild:radio z:1000 tag:menu_tag];
}

-(void)showSkillDetail:(NSString *)icon andName:(NSString *)name andDesc:(NSString *)desc{
    
    [self removeChild:[self getChildByTag:skillDetail_tag] cleanup:YES];
    
    CCSprite *detailBg = [CCSprite spriteWithFile:@"skillDetail.png"];
    detailBg.anchorPoint = ccp(1, 1);
    detailBg.position = ccp(screenSize.width - 5, screenSize.height - 5);
    [self addChild:detailBg z:1000 tag:skillDetail_tag];
    
    CCLabelTTF *lab1 = [CCLabelTTF labelWithString:name fontName:@"STHeitiK-Light" fontSize:15];
    lab1.anchorPoint = ccp(0.5, 0.5);
    lab1.position = ccp(detailBg.boundingBox.size.width * 0.5 + 5, detailBg.boundingBox.size.height - 20);
    [detailBg addChild:lab1];
    
    CCSprite *ic = [CCSprite spriteWithFile:icon];
    ic.position = ccp(15, detailBg.boundingBox.size.height - 20);
    ic.scale = 0.3;
    [detailBg addChild:ic];
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:desc dimensions:CGSizeMake(detailBg.boundingBox.size.width - 10,detailBg.boundingBox.size.height - 10 )alignment:UITextAlignmentLeft fontName:@"STHeitiK-Light" fontSize:12];
    label.anchorPoint = ccp(-0.05, 0.2);
    [detailBg addChild:label];
    
}

// 逃跑按钮
-(void)escape{
    self.hero.flipX = NO;
    CCMoveTo *to = [CCMoveTo actionWithDuration:0.5 position:ccp(screenSize.width, self.hero.position.y)];
    [self.hero runAction:[CCSequence actions:[CCRepeat actionWithAction:self.hero.runAnimate times:3],[CCSpawn actions:self.hero.runAnimate,to, nil], nil]];
    [self performSelector:@selector(escapeToOldScene) withObject:nil afterDelay:2];
    [self menuClose];
}

// 逃跑按钮点击后
-(void)escapeToOldScene{
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    BattleResult *br = [[[BattleResult alloc] init] autorelease];
    
    br.exp = 10;
    br.result = @"让领导先走!";
    br.hpMin = HEROHP;
    br.mpMin = 0;
    br.win = YES;
    
    NSData *brData = [NSKeyedArchiver archivedDataWithRootObject:br];
    [arr setObject:brData forKey:@"battleResult"];
     CCLOG(@"扣血量是多少： %d",br.hpMin);
    [[CCDirector sharedDirector] popScene];
}

// 返回按钮
-(void)itemBackClick{
    [self createNormalClickMenu];
}

// 菜单关闭
-(void)menuClose{
    [self removeChild:[self getChildByTag:skillDetail_tag] cleanup:YES];
    [self removeChild:[self getChildByTag:menu_tag] cleanup:YES];
    [self removeChild:[self getChildByTag:menubg_tag] cleanup:YES];
}

// 读秒
-(void)timeComputer{
    
    self.isTouchEnabled = YES;
    timess -- ;
    CCLabelBMFont  *label = (CCLabelBMFont  *)[self getChildByTag:computer_tag];
    if (nil == label) {
        label =[CCLabelBMFont labelWithString:@""  fntFile:@"myfont1.fnt"];
        label.scale = 0.8f;
        label.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.85f);
        [self addChild:label z:1 tag:computer_tag];
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
    CCLabelBMFont  *label = (CCLabelBMFont  *)[self getChildByTag:computer_tag];
    if (label) {
        label.visible = NO;
    }
    [self unschedule:@selector(timeComputer)];
    [self menuClose];
}

-(void)createEnemyLine{
    if (lineArray) {
        NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
        int rad = CCRANDOM_0_1();
        //*([lineArray count] -1)
        if ([arr objectForKey:@"battle"]) {
            int x = [(NSString *)[arr objectForKey:@"battle"] intValue];
            [arr removeObjectForKey:@"battle"];
            rad = x;
        }
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
                
            case 4:
            {
                etype = ENEMY_ALXMEN;
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
        int damge = 0;
        NSMutableArray *deleteArray = [NSMutableArray array];
        for (Debuff *de in enemy.debuffArray) {
            de.debuffCount -- ;
            if (de.debuffCount <= 0) {
                [deleteArray addObject:de];
            }
            damge += de.ATN;
        }
        
        for (Debuff *de in deleteArray) {
         // 移除debuff效果
            [enemy removeChild:de cleanup:YES];
            [enemy.debuffArray removeObject:de];
        }
        
        if (damge > 0) {
            // 敌人执行受伤动作
            [enemy hurtByHero:[NSString stringWithFormat:@"%d",damge]];
            // 敌人掉血动画
            [self showBlood:[NSString stringWithFormat:@"- %d",damge] andPt:enemy.position];
            
            NSMutableArray *deleteArr = [NSMutableArray array];
            
            for (Enemy *e in self.enemyArray) {
                if (ENEMY_DEAD == e.state) {
                    [deleteArr addObject:e];
                }
            }
            // 敌人数组为空即表示胜利,这里不能删除deleteArr的内容！
            if ([deleteArr count] >= [self.enemyArray count]) {
                [self win];
            } 
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
    
    if (-1 != SELECTED_SKILL) {
        // 如果选择的是技能,就显示技能效果
        Skill *skill = [self.hero.skillArray objectAtIndex:SELECTED_SKILL];
        
        // 显示技能名称
        CCSprite *showSkill = [CCSprite spriteWithFile:skill.skillNameSprite];
        showSkill.scale = 0.1f;
        showSkill.position = ccp(screenSize.width * 0.5f,screenSize.height * 0.8f);
        [self addChild:showSkill z:200 tag:skill_tag];
        CCScaleTo *scaleto = [CCScaleTo actionWithDuration:0.6 scale:0.3];
        CCFadeOut *fade = [CCFadeOut actionWithDuration:0.5];
        CCMoveTo *to = [CCMoveTo actionWithDuration:0.5 position:ccp(showSkill.position.x + 200, showSkill.position.y)];
        
        CCCallFunc *gb = [CCCallFunc actionWithTarget:self selector:@selector(bye)];
        
        [showSkill runAction:[CCSequence actions:scaleto,[CCSpawn actions:fade,to, nil],gb, nil]];
        
    }
}

/**
 * 攻击中
 */
-(void)heroAttacking:(Enemy *)enemy{
//    Enemy *enemy = [self.enemyArray objectAtIndex:0];
    int rad = CCRANDOM_0_1() * ([self.hero.attackAnimates count] -1);
    float attackDur = [(CCAnimate *)[hero.attackAnimates objectAtIndex:rad] duration];
    [hero runAction:[hero.attackAnimates objectAtIndex:rad]];
    
    // 音效
    NSString *soundName = [NSString stringWithFormat:@"attack_0%d.mp3",rad+1];
    [Sound playSound:soundName];
    
    [self performSelector:@selector(skill:) withObject:enemy afterDelay:attackDur - 0.2];
    // 攻击完后,玩家就跑回原位
    [hero performSelector:@selector(runBack) withObject:nil afterDelay:attackDur + 0.5];
    
    
}

-(void)bye{
    [self removeChild:[self getChildByTag:skill_tag] cleanup:YES];
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
        
        BOOL jump = NO;
        // 有限制移动的debuff
        for (Debuff *de in enemy.debuffArray) {
            if (0 != de.sleepTimes) {
                jump = YES;
                break;
            }
        }
        if (jump) {
            [enemy backNormal];
            [self.hero heroHurtOrDead];
            continue;
        }
        
        float dur = [enemy runToHeroTime:hero.position];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *durStr = [NSString stringWithFormat:@"%f",dur];
        [dic setObject:durStr forKey:@"dur"];
        [dic setObject:enemy forKey:@"enemy"];
        // 由于是子线程操作,需要每个判断
        [self performSelector:@selector(enemyAttackBefore:) withObject:dic afterDelay:per + dur];
        per += 4;
        
    }
    
}

-(void)enemyAttackBefore:(NSMutableDictionary *)dic{
    float dur = [[dic objectForKey:@"dur"] floatValue];
    Enemy *enemy = [dic objectForKey:@"enemy"];
    if (LOSE) {
        CCLOG(@"******************************  LOSE");
        return;
    }
    
    [enemy runToHero:NSStringFromCGPoint(hero.position)];
    [self performSelector:@selector(enemyAttacking:) withObject:enemy afterDelay:dur];
}

/**
 * 攻击中
 */
-(void)enemyAttacking:(Enemy *)enemy{
//    Enemy *enemy = [self.enemyArray objectAtIndex:0];
    float attackDur = enemy.attackAnimate.duration;
    [enemy runAction:enemy.attackAnimate];
    // 攻击音效
    [Sound playSound:@"SwordHit.mp3"];
    // 攻击开始后0.2秒敌人执行受伤动作,这样效果比较好,不然就是攻击完了,才执行受伤动作。
    NSString *damage = [NSString stringWithFormat:@"%d",enemy.enemyDamage];
    [hero performSelector:@selector(hurtByEnemy:) withObject:damage afterDelay:attackDur - 0.2];
    [self performSelector:@selector(heroShowBlood:) withObject:damage afterDelay:attackDur - 0.2];
    HEROHP += enemy.enemyDamage;
    // 攻击完后,玩家就跑回原位
    [enemy performSelector:@selector(runBack) withObject:nil afterDelay:attackDur + 0.5];
}

-(void)heroShowBlood:(NSString *)blood{
    blood = [NSString stringWithFormat:@"- %@",blood];
    [self showBlood:blood andPt:self.hero.position];
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
    if (hero.lev.hpNow <= 0) {
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
// 成功 ->胜
-(void)win{
    if (WIN) {
        return;
    }
    [self menuClose];
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
// -> 利
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
// -> !
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
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    BattleResult *br = [[[BattleResult alloc] init] autorelease];
    if (LOSE) {
        // 失败
        br.exp = 0;
        br.result = @"胜败乃兵家常事,大侠还要勤学苦练";
        br.hpMin = 0;
        br.mpMin = 0;
        br.win = NO;
    } else {
        br.exp = 10;
        br.result = @"战斗胜利,获得经验:10exp!";
        br.hpMin = HEROHP;
        br.mpMin = 0;
        br.win = YES;
    }
    NSData *brData = [NSKeyedArchiver archivedDataWithRootObject:br];
    [arr setObject:brData forKey:@"battleResult"];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
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
