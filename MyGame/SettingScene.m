//
//  SettingScene.m
//  MyGame
//
//  Created by yfzx on 13-11-6.
//
//

#import "SettingScene.h"
#import "SimpleAudioEngine.h"
#import "UserData.h"
#import "CCRadioMenu.h"

BOOL BGSound = YES;
BOOL OtherSound = YES;

@implementation SettingScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SettingScene *layer = [SettingScene node];
	
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
	}
	return self;
}

-(void)createScene{
    BGSound = YES;
    OtherSound = YES;
    CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 1)];
    layer.opacity = 100.0f;
    [self addChild:layer z:100];
    
    CCLabelTTF *lab1 = [CCLabelTTF labelWithString:@"背景音乐" fontName:@"STHeitiK-Light" fontSize:20];
    CCLabelTTF *lab2 = [CCLabelTTF labelWithString:@"音效音乐" fontName:@"STHeitiK-Light" fontSize:20];
    
    lab2.position = ccp(screenSize.width * 0.5 - 60, screenSize.height * 0.4f);
    lab1.position = ccp(screenSize.width * 0.5 - 60, screenSize.height * 0.6f);
    
    [self addChild:lab1];
    [self addChild:lab2];
    
    CCMenuItemImage *img1 = [CCMenuItemImage itemFromNormalImage:@"on.png" selectedImage:nil target:self selector:@selector(bgSoundSetting:)];
    CCMenuItemImage *img2 = [CCMenuItemImage itemFromNormalImage:@"on.png" selectedImage:nil target:self selector:@selector(soundSetting:)];
    
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    
    // 设置背景音乐
    if ([arr objectForKey:@"BGSOUND"]) {
        NSString *s = [NSString stringWithFormat:@"%@",[arr objectForKey:@"BGSOUND"]];
        if ([s isEqualToString:@"1"]) {
            img1.normalImage = [CCSprite spriteWithFile:@"on.png"];
            BGSound = YES;
        } else {
            img1.normalImage = [CCSprite spriteWithFile:@"off.png"];
            BGSound = NO;
        }
    }
    
    // 设置音效音乐
    if ([arr objectForKey:@"SOUND"]) {
        NSString *s = [NSString stringWithFormat:@"%@",[arr objectForKey:@"SOUND"]];
        if ([s isEqualToString:@"1"]) {
            img2.normalImage = [CCSprite spriteWithFile:@"on.png"];
            OtherSound = YES;
        } else {
            img2.normalImage = [CCSprite spriteWithFile:@"off.png"];
            OtherSound = NO;
        }
    }

    
    CCMenu *menu = [CCMenu menuWithItems:img1,img2, nil];
    [menu alignItemsVerticallyWithPadding:10];
    menu.position = ccp(screenSize.width * 0.65, screenSize.height * 0.5f - 10);
    
    
    [self addChild:menu];
    
    CCSprite *cls = [CCSprite spriteWithFile:@"close.png"];
    CCMenuItemSprite *itt = [CCMenuItemSprite itemFromNormalSprite:cls selectedSprite:nil target:self selector:@selector(back)];
    CCMenu *mm = [CCMenu menuWithItems:itt, nil];
    mm.position = ccp(screenSize.width - 20 , screenSize.height * 0.9);
    [self addChild:mm z: 5];
}

-(void)back{
    [[CCDirector sharedDirector] popScene];
}

-(void)bgSoundSetting:(CCMenuItemImage *)item{
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    if (BGSound) {
        item.normalImage = [CCSprite spriteWithFile:@"off.png"];
        [arr setBool:NO forKey:@"BGSOUND"];
        BGSound = NO;
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    } else {
        item.normalImage = [CCSprite spriteWithFile:@"on.png"];
        [arr setBool:YES forKey:@"BGSOUND"];
        BGSound = YES;
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    }
}

-(void)soundSetting:(CCMenuItemImage *)item{
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    if (OtherSound) {
        item.normalImage = [CCSprite spriteWithFile:@"off.png"];
        [arr setBool:NO forKey:@"SOUND"];
        OtherSound = NO;
    } else {
        item.normalImage = [CCSprite spriteWithFile:@"on.png"];
        [arr setBool:YES forKey:@"SOUND"];
        OtherSound = YES;
    }
}

@end
