//
//  SelectScene.h
//  FirstGame
//
//  Created by yfzx on 13-10-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    ParticleTypeExplosion = 1,
    ParticleTypeFire = 2,
    ParticleTypeFireworks = 3,
    ParticleTypeFlower = 4,
    ParticleTypeGalaxy = 5,
    ParticleTypeMeteor = 6,
    ParticleTypeRain = 7,
    ParticleTypeSmoke = 8,
    ParticleTypeSnow = 9,
    ParticleTypeSpiral = 10,
    ParticleTypeSun = 11,
    ParticleTypeDream = 100,
    
} ParticleType;

@interface SelectScene : CCLayer {
    
}

+(id)scene;

-(void)createScrollSelectItems;

-(void)runEffect:(ParticleType) particleType;

@end
