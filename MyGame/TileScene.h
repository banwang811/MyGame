//
//  TileScene.h
//  MyGame
//
//  Created by yfzx on 13-10-31.
//
//

#import "cocos2d.h"
#import "CCJoyStick.h"
#import "Hero.h"

@interface TileScene : CCLayer<CCJoyStickDelegate,UIAlertViewDelegate>

@property(nonatomic,retain) CCTMXTiledMap* tileMap;
@property(nonatomic,retain) Hero *hero;
@property(nonatomic,retain) CCProgressTimer *heroHP;
@property(nonatomic,retain) CCProgressTimer *heroEXP;

-(void)createCCJoyStick;
//-(void)createMap;
-(void)createHero;
-(void)createNpc;
-(void)createNpc2;
-(void)createBoss;

+(CCScene *) scene;
// 坐标转换成瓷砖坐标
- (CGPoint)tileCoordForPosition:(CGPoint)position;

-(float)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end;

-(void)battle:(NSString *)x;

//-(void)createBg;

-(void)createMenus;

@end
