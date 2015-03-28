//
//  MainScene.m
//  MyGame
//
//  Created by yfzx on 13-10-29.
//
//

#import "MainScene.h"
#import "Hero.h"
#import "TalkObject.h"
#import "TalkScene.h"
#import "BattleScene.h"
#import "LotteryScene.h"
#import "BattleResult.h"
#import "Debuff.h"

BOOL FIRST = YES;

typedef enum {
    hero_tag = 1000,
    bg_tag = 1001,
    hp_tag = 1002,
} tag_num;

float speed = 100.0f;

typedef enum {
    speak_no = 0,
    speak_npc1 = 1,
    speak_npc2 = 2,
    speak_boss = 3,
} speak_happen;

speak_happen toWhat = speak_no;

@implementation MainScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainScene *layer = [MainScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        [self createScene];
        [self createHero];
        [self createNpc];
        [self createHeader];
        [self createMenus];
        self.isTouchEnabled = YES;
        FIRST = YES;
	}
	return self;
}

-(void)dealloc{
    [super dealloc];
}

#pragma -
#pragma logicMethod
-(void)createHeader{
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"HudLayerSpriteFrame.plist"];
    CCSprite *header = [CCSprite spriteWithSpriteFrameName:@"AmokIcon2.png"];
    
    header.position = ccp(30.0f, screenSize.height - 30.0f);
    [self addChild:header z:200];
    
    // 血条底图
    CCSprite *hpBar = [CCSprite spriteWithSpriteFrameName:@"LifeBarBackground.png"];
    hpBar.color = ccRED;
    hpBar.position = ccp(header.position.x + 90.0f,header.position.y);
    [self addChild:hpBar z:200];
    // 血条
    CCProgressTimer *heroHP=[CCProgressTimer progressWithFile:@"heroHpbar.png"];
    heroHP.position = ccp(hpBar.position.x - 5, hpBar.position.y + 5);
    heroHP.percentage = 99; //当前进度
    heroHP.type=kCCProgressTimerTypeHorizontalBarLR;//进度条的显示样式
    heroHP.percentage += 1;
    [self addChild:heroHP z:200 tag:hp_tag];
}

-(void)createMenus{
    CCSprite *lottery = [CCSprite spriteWithFile:@"lotteryItem.png"];
    CCMenuItemSprite *lotteryItem = [CCMenuItemSprite itemFromNormalSprite:lottery selectedSprite:nil target:self selector:@selector(lotteryClick)];
    lotteryItem.scale = 0.5f;
    CCMenu *lotteryMenu = [CCMenu menuWithItems:lotteryItem, nil];
    lotteryMenu.position = ccp(230.0f, screenSize.height - 30.0f);
    
    Debuff *de = [Debuff deBuff:other_1];
    de.position = ccp(lotteryMenu.position.x - 2, lotteryMenu.position.y);
    de.flipX = YES;
    [de runAction:de.debuffAnimate];
    [self addChild:de z:201];
    [self addChild:lotteryMenu z:200];
    
    CCSprite *cls = [CCSprite spriteWithFile:@"close.png"];
    CCMenuItemSprite *itt = [CCMenuItemSprite itemFromNormalSprite:cls selectedSprite:nil target:self selector:@selector(back)];
    CCMenu *mm = [CCMenu menuWithItems:itt, nil];
    mm.position = ccp(screenSize.width - 20 , screenSize.height * 0.9);
    [self addChild:mm z: 5];
}

-(void)back{
    [[CCDirector sharedDirector] popScene];
}

-(void)lotteryClick{
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[LotteryScene scene]]];
}

-(void)createScene{
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    NSString *na = [arr objectForKey:@"bgs"];
    CCSprite *bg = [CCSprite spriteWithFile:na];
    bg.position = ccp(0, 0);
    bg.anchorPoint = ccp(0, 0);
    bg.opacity = 200.0f;
    [self addChild:bg z:-1 tag:bg_tag];
}

-(void)createHero{
    Hero *hero = [Hero Hero:HERO_1];
    hero.position = ccp(screenSize.width * 0.1f, screenSize.height * 0.5f);
    hero.startPt = hero.position;
    [hero HeroExcuteStand];
    [self addChild:hero z:20 tag:hero_tag];
}

-(void)createNpc{
    CCSprite *bg = (CCSprite *)[self getChildByTag:bg_tag];
    
    Hero *hero = [Hero Hero:HERO_2];
    [hero HeroExcuteStand];
    hero.flipX = YES;
    // 这里font为空，主要是因为NPC的素材大小是256x256的,在添加成menu时坐标显示不好调
    CCMenuItemFont *npc = [CCMenuItemFont itemFromString:@" " target:self selector:@selector(npcSpeak)];
    [npc setFontSize:75];
    CCMenu *menu = [CCMenu menuWithItems:npc, nil];
    menu.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f + 20);
    [bg addChild:menu];
    hero.position = menu.position;
    [bg addChild:hero];
    
    // 描述
    CCLabelTTF *head = [CCLabelTTF labelWithString:@"李莫愁" fontName:@"STHeitiK-Light" fontSize:15];
    head.position = ccp(menu.position.x, menu.position.y + 48);
    [bg addChild:head];
    
//    CCMenuItemFont *battleNpc = [CCMenuItemFont itemFromString:@"抽奖" target:self selector:@selector(lottery)];
//    CCMenu *menu2 = [CCMenu menuWithItems:battleNpc, nil];
//    menu2.position = ccp(screenSize.width * 1.1f, screenSize.height * 0.6f);
//    [bg addChild:menu2];
}

-(void)npcSpeak{
    CCLOG(@"NPC 对话开始。。。");
    // 截一张当前界面的图,防止已经暂停后再次点击其他按钮
    CCRenderTexture* renderTexture = [CCRenderTexture renderTextureWithWidth:screenSize.width height:screenSize.height];
    [renderTexture begin];
    [self visit];
    [renderTexture end];
    [renderTexture setPosition:CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f)];
    
    TalkObject *obj = [[[TalkObject alloc] init] autorelease];
    obj.speak1FrameName = @"StoryLayer.plist";
    obj.speak1PngName = @"Jebat2.png";
    
    obj.speak2FrameName = @"StoryLayer.plist";
    obj.speak2PngName = @"Teja.png";
    
    NSArray *array = [NSArray arrayWithObjects:@"如今能做的都做了，剩下的就等那女魔头来了……",
                      @"问世间，情是何物……直教人生死相许……",
                      @"女魔头...",
                      @"今天陆家庄里的人，一个也别想跑掉",
                      @"二十年过去了,你终究还是不放过我们。",
                      @"哼,受死吧！", nil];
    obj.talkMsgArray = array;
    
    toWhat = speak_npc1;
    
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[TalkScene scene:obj andBg:renderTexture]]];
    
}

-(void)lottery{
    CCLOG(@"NPC 抽奖对话开始。。。");
    // 截一张当前界面的图,防止已经暂停后再次点击其他按钮
    CCRenderTexture* renderTexture = [CCRenderTexture renderTextureWithWidth:screenSize.width height:screenSize.height];
    [renderTexture begin];
    [self visit];
    [renderTexture end];
    [renderTexture setPosition:CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f)];
    
    TalkObject *obj = [[[TalkObject alloc] init] autorelease];
    obj.speak1FrameName = @"StoryLayer.plist";
    obj.speak1PngName = @"Jebat2.png";
    
    obj.speak2FrameName = @"StoryLayer.plist";
    obj.speak2PngName = @"Wizard.png";
    
    NSArray *array = [NSArray arrayWithObjects:@"我要抽奖！",
                      @"祝你好运", nil];
    obj.talkMsgArray = array;
    
    toWhat = speak_npc2;
    
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[TalkScene scene:obj andBg:renderTexture]]];
}

-(void)changeHeroDetail{
    //    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    //    Hero *hero = (Hero *)[self getChildByTag:hero_tag];
    //    CCProgressTimer *heroHP = (CCProgressTimer *)[self getChildByTag:hp_tag];
    
}

-(void)removeShow{
    [self removeChild:[self getChildByTag:999] cleanup:YES];
    [self removeChild:[self getChildByTag:998] cleanup:YES];
}

-(void)onEnter{
    [super onEnter];
    if (FIRST) {
        FIRST = NO;
    } else {
        NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
        NSData *data = [arr objectForKey:@"battleResult"];
        if (data) {
            BattleResult *br = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            CCLOG(@"返回的战斗结果: %@",br.result);
            CCSprite *show = [CCSprite spriteWithFile:@"showResult.jpg"];
            show.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
            show.scaleX = 0.1f;
            CCLabelTTF *ttf = [CCLabelTTF labelWithString:br.result fontName:@"STHeitiK-Light" fontSize:20];
            ttf.position = show.position;
            ttf.scaleX = 0.1f;
            [self addChild:ttf z:401 tag:999];
            [self addChild:show z:400 tag:998];
            
            CCScaleTo *to = [CCScaleTo actionWithDuration:0.5 scaleX:0.8 scaleY:1];
            CCScaleTo *to2 = [CCScaleTo actionWithDuration:0.5 scale:1];
            
            [show runAction:to];
            [ttf runAction:to2];
            
            [arr removeObjectForKey:@"battleResult"];
        }
    }
    switch (toWhat) {
        case speak_npc1:
        {
            toWhat = speak_no;
            [self battle];
        }
            break;
        case speak_npc2:
        {
            toWhat = speak_no;
            [self battle2];
        }
            break;
        case speak_boss:
        {
            toWhat = speak_no;
        }
            break;
            
        default:{
            toWhat = speak_no;
        }
            break;
    }
}

-(void)battle{
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[BattleScene scene]]];
}

-(void)battle2{
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[LotteryScene scene]]];
}

#pragma -
#pragma touchMethod
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch  *touch=[touches anyObject];
    CGPoint   touchLocation = [touch locationInView:touch.view];
    CGPoint  glLocation=[[CCDirector sharedDirector] convertToGL:touchLocation];
    [self removeShow];
    [self moveNow:glLocation];
    
}

-(void)moveNow:(CGPoint)pt{
    
    Hero *hero = (Hero *)[self getChildByTag:hero_tag];
    [hero stopAllActions];
    [hero HeroExcuteStand];
    CGPoint heroEndPt = pt;
    
    CCSprite *bg = (CCSprite *)[self getChildByTag:bg_tag];
    [bg stopAllActions];
    CGPoint bgEndPt = bg.position;
    
    // 判断玩家的坐标是否越界
    if (pt.x < 40) {
        heroEndPt.x = 40;
    }
    if (pt.x > screenSize.width - 40) {
        heroEndPt.x = screenSize.width - 40;
    }
    if (pt.y > screenSize.height * 0.5) {
        heroEndPt.y = screenSize.height * 0.5f;
    }
    if (pt.y < 40) {
        heroEndPt.y = 40;
    }
    
    float len; // 位移量
    float dur; // 时间
    int   repeat; // 跑动次数
    
    // 判断方向
    if (pt.x < hero.position.x) {
        // 左边跑
        hero.flipX = YES;
        if (pt.x < screenSize.width * 0.5) {
            // 中间位置的偏移量
            float moveX = screenSize.width * 0.5 - pt.x;
            if (bg.position.x + moveX <= 0) {
                //                CCLOG(@"dfsfsdfsd %f",bg.position.x + moveX);
                bgEndPt.x = bg.position.x + moveX;
                heroEndPt.x = screenSize.width * 0.5f;
                
                len = [self distanceFromPointX:bg.position distanceToPointY:bgEndPt];
                float len2 = [self distanceFromPointX:heroEndPt distanceToPointY:hero.position];
                if (len2 > len) {
                    len = len2;
                }
                dur = len / speed;
                repeat = (dur / hero.runAnimate.duration) + 0.5f;
                
            } else {
                bgEndPt.x = 0;
                len = [self distanceFromPointX:heroEndPt distanceToPointY:hero.position];
                heroEndPt.x = heroEndPt.x + fabs(bgEndPt.x - bg.position.x);
                dur = len / speed;
                repeat = (dur / hero.runAnimate.duration) + 0.5f;
            }
        } else {
            len = [self distanceFromPointX:heroEndPt distanceToPointY:hero.position];
            dur = len / speed;
            repeat = (dur / hero.runAnimate.duration) + 0.5f;
        }
        
    } else {
        // 右边跑
        hero.flipX = NO;
        if (pt.x > screenSize.width * 0.5) {
            // 中间位置的偏移量
            //            CCLOG(@"%f",bg.position.x);
            float moveX = pt.x - screenSize.width * 0.5;
            if (bg.position.x - moveX >= screenSize.width - bg.contentSize.width) {
                bgEndPt.x = bg.position.x - moveX;
                heroEndPt.x = screenSize.width * 0.5f;
                
                len = [self distanceFromPointX:bg.position distanceToPointY:bgEndPt];
                float len2 = [self distanceFromPointX:heroEndPt distanceToPointY:hero.position];
                if (len2 > len) {
                    len = len2;
                }
                dur = len / speed;
                repeat = (dur / hero.runAnimate.duration) + 0.5f;
            } else {
                bgEndPt.x = screenSize.width - bg.contentSize.width;
                len = [self distanceFromPointX:heroEndPt distanceToPointY:hero.position];
                heroEndPt.x = heroEndPt.x - fabs(bgEndPt.x - bg.position.x);
                dur = len / speed;
                repeat = (dur / hero.runAnimate.duration) + 0.5f;
            }
        } else {
            len = [self distanceFromPointX:heroEndPt distanceToPointY:hero.position];
            dur = len / speed;
            repeat = (dur / hero.runAnimate.duration) + 0.5f;
        }
        
    }
    
    CCMoveTo *bgTo = [CCMoveTo actionWithDuration:dur position:bgEndPt];
    [bg runAction:bgTo];
    if (repeat == 0) {
        repeat = 1;
    }
    CCMoveTo *to = [CCMoveTo actionWithDuration:dur position:heroEndPt];
    [hero runAction:[CCSpawn actions:to,[CCRepeat actionWithAction:hero.runAnimate times:repeat ], nil]];
    
}

// 计算两点距离
-(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end{
    float distance;
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

@end
