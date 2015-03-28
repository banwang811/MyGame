//
//  Lev.h
//  MyGame
//
//  Created by yfzx on 13-10-29.
//
//

#import <Foundation/Foundation.h>

@interface Lev : NSObject{

}

@property(nonatomic,assign) int level; // 等级
@property(nonatomic,assign) int hpNow; // 当前血量
@property(nonatomic,assign) int totalHp; // 总血量
@property(nonatomic,assign) float ATN; // 物理攻击
@property(nonatomic,assign) float DEF; // 防御
@property(nonatomic,assign) float INT; // 法术攻击力
@property(nonatomic,assign) float nowExp; // 当前经验
@property(nonatomic,assign) float levExp; // 升级经验


@end
