//
//  LotteryScene.m
//  FirstGame
//
//  Created by yfzx on 13-10-28.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "LotteryScene.h"
#import "Lottery.h"

float lotteryRad = 0.0f;

BOOL ISSHOW = NO;

@implementation LotteryScene

@synthesize iconArray;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LotteryScene *layer = [LotteryScene node];
	
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
        ISSHOW = NO;
	}
	return self;
}

-(void)createScene{
    CCSprite *bg = [CCSprite spriteWithFile:@"dipan.png"];
    bg.scale = 0.5f;
    CCSprite *header = [CCSprite spriteWithFile:@"zhuanzhen.png"];
    header.scale = 0.5f;
    CCSprite *clickOn = [CCSprite spriteWithFile:@"kai2.png"];
    CCSprite *clickOff = [CCSprite spriteWithFile:@"kai1.png"];
    
    bg.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    header.anchorPoint = ccp(0.523, 0.625);
    header.position = bg.position;
    [self addChild:bg z:1];
    [self addChild:header z:3 tag:2];
    
    CCMenuItemSprite *item = [CCMenuItemSprite itemFromNormalSprite:clickOff selectedSprite:clickOn target:self selector:@selector(start)];
    item.scale = 0.5f;
    CCMenu *menu = [CCMenu menuWithItems:item, nil];
    [self addChild:menu z:4 tag:20000];
    [self addIcon];
    
    CCSprite *cls = [CCSprite spriteWithFile:@"close.png"];
    CCMenuItemSprite *itt = [CCMenuItemSprite itemFromNormalSprite:cls selectedSprite:nil target:self selector:@selector(back)];
    CCMenu *mm = [CCMenu menuWithItems:itt, nil];
    mm.position = ccp(screenSize.width - 20 , screenSize.height * 0.9);
    [self addChild:mm z: 5];
    
}

-(void)back{
    [[CCDirector sharedDirector] popScene];
}

-(void)addIcon{
    self.iconArray = [[NSMutableArray alloc] initWithCapacity:1];
    float max = 360.0f/12.0f;
    float min = 0.0f;
    for (int i = 1; i < 13; i++) {
        NSString *name = [NSString stringWithFormat:@"%d.jpg",i];
        Lottery *lt = [Lottery lottery:name andMsg:@""];
        lt.position = ccp(100, 200);
        lt.max = max;
        lt.min = min;
        lt.scale = 0.6f;
        CCLOG(@"%d   min = %f,max = %f",i,min,max);
        min = max;
        max += 360.0f/12.0f;
        [self addChild:lt z:2];
        [self.iconArray addObject:lt];
        if (1 == i) {
            lt.position = ccp(screenSize.width * 0.5f - 20.5, screenSize.height * 0.5 - 81);
            lt.msg = @"恭喜你,获得椰果 x 3";
        }
        if (2 == i) {
            lt.position = ccp(screenSize.width * 0.5f - 59, screenSize.height * 0.5 - 58.5);
            lt.msg = @"恭喜你,获得蓝莓 x 3";
        }
        if (3 == i) {
            lt.position = ccp(screenSize.width * 0.5f - 82, screenSize.height * 0.5 - 20.5);
            lt.msg = @"恭喜你,获得豆子 x 3";
        }
        if (4 == i) {
            lt.position = ccp(screenSize.width * 0.5f - 82, screenSize.height * 0.5 + 20.5);
            lt.msg = @"恭喜你,获得坚果 x 3";
        }
        if (5 == i) {
            lt.position = ccp(screenSize.width * 0.5f - 59, screenSize.height * 0.5 + 58.5);
            lt.msg = @"恭喜你,获得叶子 x 6";
        }
        if (6 == i) {
            lt.position = ccp(screenSize.width * 0.5f - 20.5, screenSize.height * 0.5 + 81);
            lt.msg = @"恭喜你,获得蓝莓 x 5";
        }
        
        
        if (7 == i) {
            lt.position = ccp(screenSize.width * 0.5f + 20.5, screenSize.height * 0.5 + 81);
            lt.msg = @"恭喜你,获得豆子 x 5";
        }
        if (8 == i) {
            lt.position = ccp(screenSize.width * 0.5f + 59, screenSize.height * 0.5 + 58.5);
            lt.msg = @"恭喜你,获得坚果 x 6";
        }
        if (9 == i) {
            lt.position = ccp(screenSize.width * 0.5f + 82, screenSize.height * 0.5 + 20.5);
            lt.msg = @"恭喜你,获得椰果 x 7";
        }
        if (10 == i) {
            lt.position = ccp(screenSize.width * 0.5f + 82, screenSize.height * 0.5 - 20.5);
            lt.msg = @"恭喜你,获得蓝莓 x 7";
        }
        if (11 == i) {
            lt.position = ccp(screenSize.width * 0.5f + 59, screenSize.height * 0.5 - 58.5);
            lt.msg = @"恭喜你,获得豆子 x 7";
        }
        if (12 == i) {
            lt.position = ccp(screenSize.width * 0.5f + 20.5, screenSize.height * 0.5 - 81);
            lt.msg = @"恭喜你,获得坚果 x 7";
        }
    }
}

-(void)start{
    CCMenu *menu = (CCMenu *)[self getChildByTag:20000];
    menu.isTouchEnabled = NO;
    CCSprite *header = (CCSprite *)[self getChildByTag:2];
    header.rotation = 0.0f;
    float rad = CCRANDOM_0_1()*360;
    CCRotateTo *to = [CCRotateTo actionWithDuration:5 angle:rad + 20 * 360];
    CCEaseSineInOut *iout = [CCEaseSineInOut actionWithAction:to];
    
    CCLOG(@"%f",rad);
    lotteryRad = rad;
    CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(showLottery)];
    [header runAction:[CCSequence actions:iout,func, nil]];
}

-(void)showLottery{
    for (Lottery *lt in self.iconArray) {
        if (lt.min <= lotteryRad && lt.max >= lotteryRad) {
            [self showLotteryDetail:lt];
            break;
        }
    }
}

-(void)showLotteryDetail:(Lottery *)lott{
    // 蒙版
    CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 1)];
    layer.opacity = 160.0f;
    [self addChild:layer z:100 tag:10008];
    
    CCSprite *bg1 = [CCSprite spriteWithFile:@"zhoubg1.png"];
    bg1.scale = 0.5f;
    bg1.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    
    CCSprite *bg2 = [CCSprite spriteWithFile:@"zhoubg2.png"];
    bg2.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    bg2.scale = 0.5f;
    // 图标
    CCSprite *icon = [CCSprite spriteWithFile:lott.fname];
    icon.position = ccp(screenSize.width * 0.5f - bg1.boundingBox.size.width * 0.5 + 20, bg1.position.y );
    [bg1 addChild:icon];
    icon.scale = 1.5f;
    // 内容
    CCLabelTTF *tt = [CCLabelTTF labelWithString:lott.msg fontName:@"Marker Felt" fontSize:40];
    tt.color = ccBLACK;
    tt.position = ccp(icon.position.x + icon.boundingBox.size.width, screenSize.height * 0.5f);
    tt.anchorPoint = ccp(0, 0.5);
    [bg1 addChild:tt];
    
    [self addChild:bg2 z:100 tag:10001];
    [self addChild:bg1 z:100 tag:10002];
    // 轴1
    CCSprite *zhou = [CCSprite spriteWithFile:@"zhou.png"];
    zhou.scale = 0.5f;
    zhou.position = ccp(screenSize.width * 0.5f + bg2.boundingBox.size.width * 0.5f, screenSize.height * 0.5f);
    // 轴2
    CCSprite *zhou2 = [CCSprite spriteWithFile:@"zhou.png"];
    zhou2.scale = 0.5f;
    zhou2.position = ccp(screenSize.width * 0.5f - bg2.boundingBox.size.width * 0.5f, screenSize.height * 0.5f);
    
    [self addChild:zhou z:102 tag:10003];
    [self addChild:zhou2 z:102 tag:10004];
    
    ISSHOW = YES;
    self.isTouchEnabled = YES;
}

-(void)hide{
    CCSprite *b1 = (CCSprite *)[self getChildByTag:10001];
    CCSprite *b2 = (CCSprite *)[self getChildByTag:10002];
    CCSprite *zhou1 = (CCSprite *)[self getChildByTag:10003];
    CCSprite *zhou2 = (CCSprite *)[self getChildByTag:10004];
    
    CCScaleTo *to2 = [CCScaleTo actionWithDuration:1 scaleX:0.01 scaleY:0.5];
    CCScaleTo *to1 = [CCScaleTo actionWithDuration:1 scaleX:0.01 scaleY:0.5];
    [b2 runAction:to2];
    [b1 runAction:to1];
    
    CCMoveTo *to3 = [CCMoveTo actionWithDuration:1 position:ccp(screenSize.width * 0.5f - zhou2.boundingBox.size.width * 0.5, zhou2.position.y)];
    [zhou2 runAction:to3];
    
    CCMoveTo *to = [CCMoveTo actionWithDuration:1 position:ccp(screenSize.width * 0.5f + zhou1.boundingBox.size.width * 0.5, zhou1.position.y)];
    [zhou1 runAction:to];
    
    [self performSelector:@selector(close) withObject:nil afterDelay:1.2];
}

-(void)close{
    ISSHOW = NO;
    self.isTouchEnabled = NO;
    [self removeChild:[self getChildByTag:10008] cleanup:YES];
    
    [self removeChild:[self getChildByTag:10001] cleanup:YES];
    [self removeChild:[self getChildByTag:10002] cleanup:YES];
    [self removeChild:[self getChildByTag:10003] cleanup:YES];
    [self removeChild:[self getChildByTag:10004] cleanup:YES];
    
    CCMenu *menu = (CCMenu *)[self getChildByTag:20000];
    menu.isTouchEnabled = YES;
}

#pragma -
#pragma ccTouch
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (ISSHOW) {
        [self hide];
    }
}

@end
