//
//  SelectHero.m
//  MyGame
//
//  Created by yfzx on 13-11-5.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "SelectHero.h"
#import "CCRadioMenu.h"
#import "TileScene.h"
#import "LoadScene.h"
#import "UserData.h"

int selected = 0;

@implementation SelectHero

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SelectHero *layer = [SelectHero node];
	
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
        [self createScene];
        [self createMenu_play];
	}
	return self;
}

-(void)createScene{
    
    CCSprite *bg = [CCSprite spriteWithFile:@"denglu_bj.jpg"];
    bg.scaleX = screenSize.width / bg.contentSize.width;
    bg.scaleY = screenSize.height / bg.contentSize.height;
    bg.anchorPoint = ccp(0, 0);
    [self addChild:bg z:-1];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LevelSelection.plist"];
    
    // 角色1 默认选择
    CCSprite *normal = [CCSprite spriteWithSpriteFrameName:@"Character0NonSelected.png"];
    CCSprite *selected = [CCSprite spriteWithSpriteFrameName:@"Character0Selected.png"];
    CCMenuItemSprite *menuSprite = [CCMenuItemSprite itemFromNormalSprite:normal selectedSprite:selected target:self selector:@selector(heroSelect:)];
    menuSprite.tag = 0;
    
    
    // 角色2
    CCSprite *normal1 = [CCSprite spriteWithSpriteFrameName:@"Character1NonSelected.png"];
    CCSprite *selected1 = [CCSprite spriteWithSpriteFrameName:@"Character1Selected.png"];
    CCMenuItemSprite *menuSprite1 = [CCMenuItemSprite itemFromNormalSprite:normal1 selectedSprite:selected1 target:self selector:@selector(heroSelect:)];
    menuSprite1.tag = 1;
    
    // 角色3
    CCSprite *normal2 = [CCSprite spriteWithSpriteFrameName:@"Character2NonSelected.png"];
    CCSprite *selected2 = [CCSprite spriteWithSpriteFrameName:@"Character2Selected.png"];
    CCMenuItemSprite *menuSprite2 = [CCMenuItemSprite itemFromNormalSprite:normal2 selectedSprite:selected2 target:self selector:@selector(heroSelect:)];
    menuSprite2.tag = 2;
    
    CCRadioMenu *radio = [CCRadioMenu menuWithItems:menuSprite,menuSprite1,menuSprite2, nil];
    [radio setSelectedItem_:menuSprite];
    [menuSprite selected];
    [radio alignItemsHorizontallyWithPadding:10];
    
    [self addChild:radio];
    CCSprite *cls = [CCSprite spriteWithFile:@"close.png"];
    CCMenuItemSprite *itt = [CCMenuItemSprite itemFromNormalSprite:cls selectedSprite:nil target:self selector:@selector(back)];
    CCMenu *mm = [CCMenu menuWithItems:itt, nil];
    mm.position = ccp(screenSize.width - 20 , screenSize.height * 0.9);
    [self addChild:mm z: 5];
}

-(void)back{
    [[CCDirector sharedDirector] popScene];
}

-(void)createMenu_play{
    CCSprite *playNormal = [CCSprite spriteWithSpriteFrameName:@"PlayButton.png"];
    CCSprite *playSelected = [CCSprite spriteWithSpriteFrameName:@"PlayButton.png"];
    playSelected.color = ccRED;
    CCMenuItemSprite *menuSprite = [CCMenuItemSprite itemFromNormalSprite:playNormal selectedSprite:playSelected target:self selector:@selector(start:)];
    CCMenu *menu = [CCMenu menuWithItems:menuSprite, nil];
    menu.position = ccp(screenSize.width - 60, 30);
    [self addChild:menu z:1 tag:100];
}

-(void)heroSelect:(CCNode *)node{
    selected = node.tag;
}

-(void)start:(CCMenuItem *)it{
    it.isEnabled = NO;
    [self performSelectorInBackground:@selector(jumpToScene) withObject:nil];
}

-(void)jumpToScene{
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    // 设置用户信息
    [arr setObject:[NSString stringWithFormat:@"%d",selected] forKey:@"selectHero"];
    UserData *userData = [[[UserData alloc] init] autorelease];
    userData.lev = 1;
    userData.heroType = selected;
    userData.procession = 1;
    userData.map = 1;
//    userData.bgsound = YES;
//    userData.sound = YES;
    NSData *brData = [NSKeyedArchiver archivedDataWithRootObject:userData];
    [arr setObject:brData forKey:@"USERDATA"];
    
    [self performSelectorOnMainThread:@selector(go) withObject:nil waitUntilDone:NO];
}

-(void)go{
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[LoadScene scene]]];
}

@end
