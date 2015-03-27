//
//  Lottery.h
//  FirstGame
//
//  Created by yfzx on 13-10-28.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Lottery : CCSprite {
    
}

@property(nonatomic,retain) NSString *msg;

@property(nonatomic,retain) NSString *fname;

@property(nonatomic,assign) float max;

@property(nonatomic,assign) float min;

+(Lottery *)lottery:(NSString *)name andMsg:(NSString *)content;

@end
