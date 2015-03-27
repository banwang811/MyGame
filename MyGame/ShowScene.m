//
//  ShowScene.m
//  FirstGame
//
//  Created by yfzx on 13-10-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ShowScene.h"
#import "SelectScene.h"

int nowScene = 1;

@implementation ShowScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ShowScene *layer = [ShowScene node];
	
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
        [self createBg];
	}
	return self;
}

-(void)createBg{
    CCSprite *bg = [CCSprite spriteWithFile:@"resloading1.jpg"];
    bg.scale = screenSize.width / bg.contentSize.width;
    bg.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    [self addChild:bg];
    
    CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 1)];
    layer.opacity = 160.0f;
    [self addChild:layer];
    [self show];
    
}

-(void)show{
    self.isTouchEnabled = NO;
    if (nowScene > 5) {
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[SelectScene scene]]];
        return;
    }
    [self removeChild:[self getChildByTag:100] cleanup:YES];
    NSString *name = [NSString stringWithFormat:@"resloadingStr_%d.png",nowScene];
    CCSprite *show = [CCSprite spriteWithFile:name];
    show.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    show.scale = 0.1f;
    [self addChild:show z:1 tag:100];
    CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(showOver)];
    CCScaleTo *to = [CCScaleTo actionWithDuration:0.5 scale:1];
    [show runAction:[CCSequence actions:to,func, nil]];
    nowScene ++;
}

-(void)showOver{
    self.isTouchEnabled = YES;
}


#pragma -
#pragma ccTouch
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self show];
}

@end
