//
//  LoadScene.m
//  MyGame
//
//  Created by yfzx on 13-11-5.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "LoadScene.h"
#import "Hero.h"
#import "SimpleAudioEngine.h"
#import "TileScene.h"

#define loadStr @"玩命加载中..."

int loadnow = 0;

int loadOK = 0;

@implementation LoadScene

@synthesize loadScene;

-(void)dealloc{
    if (loadScene) {
        [loadScene release];
    }
    [super dealloc];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LoadScene *layer = [LoadScene node];
	
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
	if( (self=[super init])) {
        // 创建场景
        [self createScene];
        [self schedule:@selector(loadings) interval:0.2];
        [NSThread detachNewThreadSelector:@selector(loadSound) toTarget:self withObject:nil];
        [self createSC];
	}
	return self;
}

-(void)createScene{
    CCSprite *bg = [CCSprite spriteWithFile:@"denglu_bj.jpg"];
    bg.scaleX = screenSize.width / bg.contentSize.width;
    bg.scaleY = screenSize.height / bg.contentSize.height;
    bg.anchorPoint = ccp(0, 0);
    [self addChild:bg];
    
    CCSprite *bbg = [CCSprite spriteWithFile:@"loadingbg.png"];
    bbg.anchorPoint = ccp(0, 0.5f);
    bbg.position = ccp(20,120);
    [self addChild:bbg];
    
    bbg.scaleX = 0.8f;
    
    CCProgressTimer *processing = [CCProgressTimer progressWithFile:@"loading.png"];  //进度条
    processing.anchorPoint = ccp(0, 0.5);
    processing.position = ccp(20,122);
    processing.type = kCCProgressTimerTypeHorizontalBarLR;
    processing.percentage=1; //当前进度
    processing.scaleX = 0.8f;
    
    [self addChild:processing z:3 tag:102];
    
    CCLabelTTF *ttf = [CCLabelTTF labelWithString:@"数据加载中..." fontName:@"STHeitiK-Light" fontSize:12];
    ttf.anchorPoint = ccp(0, 0.5);
    ttf.position = ccp(20, 100);
    [self addChild:ttf];
    
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    int IntType = [(NSString *)[arr objectForKey:@"selectHero"] intValue];
    CCLOG(@"选择的英雄为： %d",IntType);
    Hero *hero ;
    switch (IntType) {
        case HERO_0:
        {
            // 创建 跑动的 闪电男
            hero = [Hero Hero:HERO_0];
        }
            break;
            
        case HERO_1:
        {
            // 创建 跑动的 帅刀男
            hero = [Hero Hero:HERO_1];
        }
            break;
            
        case HERO_2:
        {
            // 创建 跑动的 斗篷妹
            hero = [Hero Hero:HERO_2];
        }
            break;
        default:
        {
            hero = [Hero Hero:HERO_0];
        }
            break;
    }
    hero.anchorPoint = ccp(0.5, 0.5);
    hero.position = ccp(screenSize.width - 60, 120);
    [hero HeroExcuteRun];
    [self addChild:hero z:2 tag:103];
    
    CCLabelTTF *newGame = [CCLabelTTF labelWithString:@"玩命加载中..." fontName:@"STHeitiK-Light" fontSize:12];
    newGame.position = ccp(hero.position.x,hero.position.y - 40);
    [self addChild:newGame z:2 tag:104];
    
}

-(void)loadings{
    loadnow ++;
    if (loadnow > [loadStr length]) {
        loadnow = 0;
    }
    NSString *lo = [loadStr substringWithRange:NSMakeRange(0,loadnow)];
    CCLabelTTF *newGame = (CCLabelTTF *)[self getChildByTag:104];
    [newGame setString:lo];
    CCProgressTimer *processing = (CCProgressTimer *)[self getChildByTag:102];
    processing.percentage += 5;
    if (loadOK >= 2 && processing.percentage >= 100) {
        [self unschedule:@selector(loadings)];
        [self toScene];
    }
}

-(void)loadSound{
    
    CCLOG(@"加载声音。。。。。");
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Heartbeat.mp3"];//hero心跳声
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"BGM1.mp3"];//开场背景音
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"BossBGM1.mp3"];//boss出场背景音
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"JebatVoice.mp3"];//hero攻击1
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"attack_01.mp3"];//hero攻击2
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"attack_02.mp3"];//boss攻击
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"attack_03.mp3"];//hero攻击3
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"attack_04.mp3"];//hero攻击4
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"attack_05.mp3"];//hero攻击5
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"JebatDie.mp3"];//hero死亡
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"JebatHurt.mp3"];//hero受伤
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"breathMale2.mp3"];//hero奔跑
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"DamakVoice.mp3"];//enemy受伤
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Blood0.mp3"];//enemy受伤1
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Blood1.mp3"];//enemy受伤2
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Blood2.mp3"];//enemy受伤3
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"EnemyAttackSound1.mp3"];//enemy进攻
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Boss1WarCry.mp3"];//boss出场
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"JebatJump.mp3"];//跳跃1
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"DamakJump.mp3"];//跳跃2
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"WinGame.mp3"];//游戏胜利
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"LostGame.mp3"];//游戏失败
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"TuahSlice.mp3"];//抽刀
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"ShortSword.mp3"];//挥短刀
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"LongSword.mp3"];//挥长枪
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"SwordHit.mp3"];//刀剑碰撞
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"SultanWave.mp3"];//冷却完成
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"special-02.wav"];//技能波
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Potion.mp3"];//喝血瓶
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"MenuTransition.mp3"];//暂停
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"maleDead1.mp3"];//男死亡1
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"maleDead2.mp3"];//男死亡2
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"maleDead3.mp3"];//男死亡3
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"maleDead4.mp3"];//男死亡4
    
    loadOK += 1;
}

-(void)createSC{
    // 貌似子线程里面创建CCScene有问题
    CCLOG(@"加载场景。。。。。");
    self.loadScene = [TileScene scene];
    loadOK += 1;
    
}

-(void)go{
//    self.loadScene = [TileScene scene];
}

-(void)toScene{
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:self.loadScene]];
}

@end
