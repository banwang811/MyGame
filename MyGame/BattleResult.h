//
//  BattleResult.h
//  MyGame
//
//  Created by yfzx on 13-10-30.
//
//

#import <Foundation/Foundation.h>

@interface BattleResult : NSObject<NSCoding>

@property(nonatomic,retain) NSString *result;
@property(nonatomic,assign) float exp;
@property(nonatomic,assign) int hpMin;
@property(nonatomic,assign) int mpMin;
@property(nonatomic,assign) BOOL win;

@end
