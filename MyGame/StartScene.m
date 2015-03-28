//
//  StartScene.m
//  MyGame
//
//  Created by yfzx on 13-11-5.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "StartScene.h"
#import "CCRadioMenu.h"
#import "SelectHero.h"
#import "TileScene.h"
#import "SettingScene.h"
#import "LoadScene.h"
#import "Sound.h"

@implementation StartScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StartScene *layer = [StartScene node];
	
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
        [self runEffect];
	}
	return self;
}

-(void)createScene{
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    NSData *userData = [arr objectForKey:@"USERDATA"];
    
    CCSprite *bg = [CCSprite spriteWithFile:@"denglu_bj.jpg"];
    bg.scaleX = screenSize.width / bg.contentSize.width;
    bg.scaleY = screenSize.height / bg.contentSize.height;
    bg.anchorPoint = ccp(0, 0);
    [self addChild:bg z:-2];

    CCLabelTTF *newGame = [CCLabelTTF labelWithString:@"新游戏" fontName:@"STHeitiK-Light" fontSize:20];
    CCLabelTTF *continueGame = [CCLabelTTF labelWithString:@"继续游戏" fontName:@"STHeitiK-Light" fontSize:20];
    CCLabelTTF *setting = [CCLabelTTF labelWithString:@"设置" fontName:@"STHeitiK-Light" fontSize:20];
    CCLabelTTF *aboutUs = [CCLabelTTF labelWithString:@"关于" fontName:@"STHeitiK-Light" fontSize:20];
    
    CCMenuItemLabel *newGameItem = [CCMenuItemLabel itemWithLabel:newGame target:self selector:@selector(newGame)];
    CCMenuItemLabel *continueGameItem = [CCMenuItemLabel itemWithLabel:continueGame target:self selector:@selector(continueGame)];
    CCMenuItemLabel *settingItem = [CCMenuItemLabel itemWithLabel:setting target:self selector:@selector(setting)];
    CCMenuItemLabel *aboutUsItem = [CCMenuItemLabel itemWithLabel:aboutUs target:self selector:@selector(aboutUs)];
    
    CCRadioMenu *menu = [CCRadioMenu menuWithItems:newGameItem,continueGameItem,settingItem,aboutUsItem, nil];
    
    if (!userData) {
        continueGameItem.isEnabled = NO;
    }
    
    menu.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    [menu alignItemsVerticallyWithPadding:20];
    
    [self addChild:menu];
    
    [Sound playBGSound:@"BGM1.mp3"];
    
    
}

-(void)runEffect{
    [self removeChildByTag:10001 cleanup:YES];
    CCParticleSystem* system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"fire.plist"];
    system.autoRemoveOnFinish = YES;
    [self addChild: system z:1 tag:10001];
}

-(void)newGame{
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[SelectHero scene]]];
}

-(void)continueGame{
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[LoadScene scene]]];
}

-(void)setting{
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[SettingScene scene]]];
}

-(void)aboutUs{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"关于我们" message:@"一个小游戏。" delegate:nil cancelButtonTitle:@"好吧" otherButtonTitles:nil];
    [al show];
    [al release];
}

@end
