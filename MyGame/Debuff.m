//
//  Debuff.m
//  FirstGame
//
//  Created by yfzx on 13-10-25.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Debuff.h"


@implementation Debuff

@synthesize debuffAnimate,debuffCount,dtype,ATN,ITN,sleepTimes;

-(void)dealloc{
    [debuffAnimate release];
    [super dealloc];
}

//+(Debuff *)deBuff:(debuff_type)type andPt:(CGPoint)pt{
//    switch (type) {
//        case debuff_1:
//        {
//            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//            [frameCache addSpriteFramesWithFile:@"yunxuan.plist"];
//            Debuff *debuff = [Debuff spriteWithSpriteFrameName:@"yunxuan_1.png"];
//            CCAnimate *animate = [debuff Animate:@"yunxuan_" andCount:6 andDelay:0.5/6.0];
//            debuff.debuffAnimate = [CCRepeatForever actionWithAction:animate];
//            debuff.position = ccp(pt.x + 45, pt.y + 60);
//            debuff.debuffCount = 1;
//            debuff.dtype = debuff_1;
//            debuff.opacity = 160.0f;
//            return debuff;
//        }
//            break;
//            
//            
//        case debuff_2:
//        {
//            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//            [frameCache addSpriteFramesWithFile:@"zengyi.plist"];
//            Debuff *debuff = [Debuff spriteWithSpriteFrameName:@"zengyi_1.png"];
//            CCAnimate *animate = [debuff Animate:@"zengyi_" andCount:9 andDelay:1/9.0];
//            debuff.debuffAnimate = [CCRepeatForever actionWithAction:animate];
//            debuff.position = ccp(pt.x + 30, pt.y + 20);
//            debuff.debuffCount = 1;
//            debuff.dtype = debuff_2;
//            debuff.opacity = 160.0f;
//            return debuff;
//        }
//            break;
//            
//        case debuff_3:
//        {
//            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//            [frameCache addSpriteFramesWithFile:@"zhongdu.plist"];
//            Debuff *debuff = [Debuff spriteWithSpriteFrameName:@"zhongdu_1.png"];
//            CCAnimate *animate = [debuff Animate:@"zhongdu_" andCount:8 andDelay:1/8.0];
//            debuff.debuffAnimate = [CCRepeatForever actionWithAction:animate];
//            debuff.position = ccp(pt.x + 40, pt.y);
//            debuff.debuffCount = 1;
//            debuff.dtype = debuff_3;
//            debuff.opacity = 160.0f;
//            return debuff;
//        }
//            break;
//            
//            
//            
//        default:
//            break;
//    }
//    
//    return nil;
//}

-(void)setDebuffPt:(CGPoint)pt{
    CCLOG(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ %f,%f",self.position.x,self.position.y);
    switch (self.dtype) {
        case debuff_1:
            // 因为敌人sprite的大小是 256x256
//            self.position = ccp(pt.x + 50, pt.y + 60);
            self.position = ccp(128, 128);
            break;
            
        case debuff_2:
//            self.position = ccp(pt.x + 45, pt.y + 20);
            self.position = ccp(128, 128 + 20);
            break;
            
        case debuff_3:
//            self.position = ccp(pt.x + 60, pt.y);
            self.position = ccp(128 + 5, 128 + 5);
            break;
            
        case debuff_4:
            //            self.position = ccp(pt.x + 60, pt.y);
            self.position = ccp(128, 128 + 10);
            break;
            
        default:
            break;
    }

}

+(Debuff *)deBuff:(debuff_type)type{
    switch (type) {
        case debuff_1:
        {
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"yunxuan.plist"];
            Debuff *debuff = [Debuff spriteWithSpriteFrameName:@"yunxuan_1.png"];
            CCAnimate *animate = [debuff Animate:@"yunxuan_" andCount:6 andDelay:0.5/6.0];
            debuff.debuffAnimate = [CCRepeatForever actionWithAction:animate];
            debuff.debuffCount = 2;
            debuff.dtype = debuff_1;
            debuff.opacity = 160.0f;
            debuff.ATN = 5;
            debuff.ITN = 2;
            debuff.scale = 0.6;
            return debuff;
        }
            break;
            
            
        case debuff_2:
        {
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"zengyi.plist"];
            Debuff *debuff = [Debuff spriteWithSpriteFrameName:@"zengyi_1.png"];
            CCAnimate *animate = [debuff Animate:@"zengyi_" andCount:9 andDelay:1/9.0];
            debuff.debuffAnimate = [CCRepeatForever actionWithAction:animate];
            debuff.debuffCount = 2;
            debuff.dtype = debuff_2;
            debuff.opacity = 160.0f;
            debuff.ATN = 2;
            debuff.ITN = 5;
            debuff.scale = 0.6;
            return debuff;
        }
            break;
            
        case debuff_3:
        {
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"zhongdu.plist"];
            Debuff *debuff = [Debuff spriteWithSpriteFrameName:@"zhongdu_1.png"];
            CCAnimate *animate = [debuff Animate:@"zhongdu_" andCount:8 andDelay:1/8.0];
            debuff.debuffAnimate = [CCRepeatForever actionWithAction:animate];
            debuff.debuffCount = 2;
            debuff.dtype = debuff_3;
            debuff.opacity = 160.0f;
            debuff.ATN = 4;
            debuff.ITN = 4;
            debuff.scale = 0.6;
            return debuff;
        }
            break;
            
        case debuff_4:
        {
            // 音波锁
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"yinbo.plist"];
            Debuff *debuff = [Debuff spriteWithSpriteFrameName:@"yinbo_1.png"];
            CCAnimate *animate = [debuff Animate:@"yinbo_" andCount:10 andDelay:1/10.0];
            debuff.debuffAnimate = [CCRepeatForever actionWithAction:animate];
            debuff.rotation = 90;
            debuff.debuffCount = 2;
            debuff.dtype = debuff_4;
            debuff.opacity = 160.0f;
            debuff.sleepTimes = 1;
            debuff.ATN = 0;
            debuff.ITN = 0;
            debuff.scale = 0.3;
            return debuff;
        }
            break;
            
            // 下面是其他效果,与debuff无关,主要是懒的再写个其他动态效果的类
        case other_1:{
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"Effect_Active.plist"];
            Debuff *debuff = [Debuff spriteWithSpriteFrameName:@"hekl_1.png"];
            CCAnimate *animate = [debuff Animate:@"hekl_" andCount:11 andDelay:1/11.0];
            debuff.debuffAnimate = [CCRepeatForever actionWithAction:animate];
            debuff.debuffCount = 0;
            debuff.dtype = other_1;
            debuff.ATN = 0;
            debuff.ITN = 0;
            return debuff;
        }
            break;
            
            
        default:
            break;
    }
    
    return nil;
}

-(CCAnimate *)Animate:(NSString *)fileName andCount:(int)count andDelay:(float)delay{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i=1; i<=count; i++) {
        NSString *path = [NSString stringWithFormat:@"%@%d.png",fileName,i];
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:path];
        [array addObject:frame];
    }
    CCAnimation *ation = [CCAnimation animationWithFrames:array delay:delay];
    [array release];
    CCAnimate *animate = [CCAnimate actionWithAnimation:ation];
    return animate;
}

@end
