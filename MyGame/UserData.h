//
//  UserData.h
//  MyGame
//
//  Created by yfzx on 13-11-6.
//
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject<NSCoding>

@property(nonatomic,assign) int heroType; // 英雄类型
@property(nonatomic,assign) int lev; // 等级
@property(nonatomic,assign) int hpNow; // 血量
@property(nonatomic,assign) int mpNow; // 蓝量
@property(nonatomic,assign) float exp; // 经验
@property(nonatomic,assign) int procession; // 游戏进度
@property(nonatomic,assign) int map; // 所在地图

//@property(nonatomic,assign) BOOL bgsound; // 背景音乐
//@property(nonatomic,assign) BOOL sound; // 音效音乐

@end
