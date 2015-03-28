//
//  TalkScene.m
//  FirstGame
//
//  Created by yfzx on 13-10-23.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "TalkScene.h"

typedef enum {
    talk_1 = 2001,
    talk_2 = 2002,
    talk_1_box = 3001,
    talk_2_box = 3002,
    talk_1_box_msg = 4001,
    talk_2_box_msg = 4002,
    talk_bg = 5001,
    talk_bg_black = 5002,
} TalkScene_tag_num;


@implementation TalkScene

@synthesize talkObj;
@synthesize tx;

int talkCount = 0;

+(CCScene *) scene:(TalkObject *)tkObj andBg:(CCRenderTexture*)texture
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
//	TalkScene *layer = [TalkScene node];
    
    TalkScene *layer = [[[TalkScene alloc] initWithObj:tkObj andBg:texture] autorelease];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) initWithObj:(TalkObject *)tkObj andBg:(CCRenderTexture*)texture
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        self.talkObj = tkObj;
        self.tx = texture;
        [self createBgScene];
        [self createTalkScene];
        [self performSelector:@selector(talking) withObject:nil afterDelay:0.5];
	}
	return self;
}

-(void)dealloc{
    [talkObj release];
    [tx release];
    [super dealloc];
}

#pragma -
#pragma logicMethod
-(void)createBgScene{
    [self addChild:self.tx z:-1];
    CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 1)];
    layer.opacity = 160.0f;
    [self addChild:layer z:0];
}

-(void)createTalkScene{
    // 加载对话人物plist
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:self.talkObj.speak1FrameName];
    [frameCache addSpriteFramesWithFile:self.talkObj.speak2FrameName];
    
    // 创建对话人物
    CCSprite *speak1 = [CCSprite spriteWithSpriteFrameName:self.talkObj.speak1PngName];
    speak1.position = ccp(50, 50);
    speak1.scale = 0.6f;
    CCSprite *talk1 = [CCSprite spriteWithFile:@"talk3.png"];
    talk1.position = ccp(85, 55);
    talk1.anchorPoint = ccp(0, 0.5);
    if (screenSize.width < 500) {
        talk1.scaleX = 0.9;
    }
    [self addChild:talk1 z:1 tag:talk_1_box];
    [self addChild:speak1 z:1 tag:talk_1];
    // 说话内容
    CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(talk1.boundingBox.size.width - 20,talk1.boundingBox.size.height - 4 )alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:20];
    label1.position = ccp(talk1.position.x + 30, talk1.position.y - 20);
    label1.anchorPoint = talk1.anchorPoint;
    [self addChild:label1 z:1 tag:talk_1_box_msg];
    
    // 其他/NPC 头像,对话框
    CCSprite *speak2 = [CCSprite spriteWithSpriteFrameName:self.talkObj.speak2PngName];
    speak2.position = ccp(screenSize.width - 50, screenSize.height - 60);
    speak2.scale = 0.6f;
    CCSprite *talk2 = [CCSprite spriteWithFile:@"talk3.png"];
    talk2.position = ccp(screenSize.width - 85, screenSize.height - 50);
    talk2.anchorPoint = ccp(1, 0.5);
    if (screenSize.width < 500) {
        talk2.scaleX = 0.9;
    }
    [self addChild:talk2 z:1 tag:talk_2_box];
    [self addChild:speak2 z:1 tag:talk_2];
    // 说话内容
    CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(talk2.boundingBox.size.width - 20,talk2.boundingBox.size.height - 4 )alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:20];
    label2.position = ccp(talk2.position.x + 10, talk2.position.y - 20);
    label2.anchorPoint = talk2.anchorPoint;
    [self addChild:label2 z:1 tag:talk_2_box_msg];
    
}

// 对话ing
-(void)talking{
    self.isTouchEnabled = YES;
    if (self.talkObj.talkMsgArray) {
        if (talkCount >= [self.talkObj.talkMsgArray count]) {
            [self talkEnd];
            return;
        }
        CCSprite *talkBox1 = (CCSprite *)[self getChildByTag:talk_1_box];
        CCSprite *talkBox2 = (CCSprite *)[self getChildByTag:talk_2_box];
        CCLabelTTF *label1 = (CCLabelTTF *)[self getChildByTag:talk_1_box_msg];
        CCLabelTTF *label2 = (CCLabelTTF *)[self getChildByTag:talk_2_box_msg];
        // 1 说
        NSString *msg = [self.talkObj.talkMsgArray objectAtIndex:talkCount];
        if (talkCount % 2 == 0) {
            // 主角说话
            talkBox2.visible = NO;
            label2.visible = NO;
            talkBox1.visible = YES;
            label1.visible = YES;
            [label1 setString:msg];
        } else {
            // NPC说话
            talkBox1.visible = NO;
            label1.visible = NO;
            talkBox2.visible = YES;
            label2.visible = YES;
            [label2 setString:msg];
        }
        
        talkCount ++;
        
    } else {
        [self talkEnd];
    }
}

-(void)talkEnd{
    talkCount = 0;
    [[CCDirector sharedDirector] popScene];
}

#pragma -
#pragma ccTouch
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self talking];
}

@end
