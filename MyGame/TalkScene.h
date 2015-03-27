//
//  TalkScene.h
//  FirstGame
//
//  Created by yfzx on 13-10-23.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TalkObject.h"

@interface TalkScene : CCLayer {
    
}

@property(nonatomic,retain) TalkObject *talkObj;
@property(nonatomic,retain) CCRenderTexture* tx;

+(CCScene *) scene:(TalkObject *)tkObj andBg:(CCRenderTexture*)texture;

-(id) initWithObj:(TalkObject *)tkObj andBg:(CCRenderTexture*)texture;

-(void)createBgScene;

-(void)createTalkScene;

-(void)talking;

-(void)talkEnd;

@end
