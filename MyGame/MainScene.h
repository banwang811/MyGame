//
//  MainScene.h
//  MyGame
//
//  Created by yfzx on 13-10-29.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainScene : CCLayer

+(CCScene *) scene;

-(void)createScene;

-(void)createHero;

-(void)createNpc;

-(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end;
-(void)moveNow:(CGPoint)pt;

-(void)createHeader;
-(void)createMenus;

-(void)battle;

-(void)battle2;

@end
