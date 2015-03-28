//
//  LoadScene.h
//  MyGame
//
//  Created by yfzx on 13-11-5.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LoadScene : CCLayer {
    
}

@property(nonatomic,retain) CCScene *loadScene;

+(CCScene *) scene;

-(void)createScene;

-(void)createSC;

-(void)toScene;

@end
