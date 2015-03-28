//
//  LotteryScene.h
//  FirstGame
//
//  Created by yfzx on 13-10-28.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Lottery.h"

@interface LotteryScene : CCLayer {
    
}

@property(nonatomic,retain) NSMutableArray *iconArray;

+(CCScene *) scene;

-(void)createScene;

-(void)addIcon;

-(void)showLotteryDetail:(Lottery *)lott;

@end
