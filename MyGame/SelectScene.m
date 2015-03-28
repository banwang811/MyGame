//
//  SelectScene.m
//  FirstGame
//
//  Created by yfzx on 13-10-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "SelectScene.h"
#import "CCScrollLayer.h"
#import "MainScene.h"
#import "TileScene.h"


@implementation SelectScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SelectScene *layer = [SelectScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        [self createScrollSelectItems];
	}
	return self;
}

-(void)createScrollSelectItems{
    [self runEffect:ParticleTypeDream];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    for (int i=1; i < 4; i++) {
        CCLayer *layer = [[[CCLayer alloc] init] autorelease];
        NSString *name = [NSString stringWithFormat:@"litte_%d.png",i];
        CCMenuItemImage *image = [CCMenuItemImage itemFromNormalImage:name
                                                        selectedImage:nil
                                                               target:self
                                                             selector:@selector(actions:)];
        image.tag = i;
        
        NSString *addr ;
        switch (i) {
            case 1:
                addr = @"迷雾森林--横版界面";
                break;
                
            case 2:
                addr = @"蓬莱岛--瓷砖界面";
                break;
                
            case 3:
                addr = @"还待开发。。。";
                image.isEnabled = NO;
                image.color = ccGRAY;
                break;
                
            case 4:
                addr = @"火焰之地";
                break;
                
            default:
                break;
        }
        
        CCMenuItemFont *text = [CCMenuItemFont itemFromString:addr];
        text.fontSize = 15;
        
        CCMenu *menu = [CCMenu menuWithItems: text,image, nil];
        [menu alignItemsVerticallyWithPadding:20];
        [layer addChild: menu];
        
        menu.position = ccp(screenSize.width * 0.5, screenSize.height * 0.6 - 20);
        
        [array addObject:layer];
        
    }
    
    int scrollLayerOffset ;
    if (screenSize.width > 480) {
        scrollLayerOffset = 250;
    } else {
        scrollLayerOffset = 180;
    }
    
    CCScrollLayer *scrollLayer = [[CCScrollLayer alloc] initWithLayers:array widthOffset:scrollLayerOffset];
    
    [self addChild:scrollLayer z:2];
}

-(void)actions:(CCNode *)node{
    NSUserDefaults* arr=[NSUserDefaults standardUserDefaults];
    switch (node.tag) {
        case 1:
            [arr setObject:@"bg2.png" forKey:@"bgs"];
            break;
            
        case 2:
            [arr setObject:@"bg6.png" forKey:@"bgs"];
            [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[TileScene scene]]];
            return;
            break;
            
        case 3:
            [arr setObject:@"bg4.png" forKey:@"bgs"];
            break;
            
        case 4:
            [arr setObject:@"bg5.png" forKey:@"bgs"];
            break;
            
        default:
            [arr setObject:@"bg2.png" forKey:@"bgs"];
            break;
    }
    
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[MainScene scene]]];
    
}

/**
 * 执行cocos2d自带粒子效果
 */
-(void)runEffect:(ParticleType) particleType{
    // 清除任何以前使用过的粒子效果
    [self removeChildByTag:1000 cleanup:YES];
    
    CCParticleSystem* system;
    switch (particleType) {
        case ParticleTypeExplosion:
            system = [CCParticleExplosion node];
            break;
        case ParticleTypeFire:
            system = [CCParticleFire node];
            break;
        case ParticleTypeFireworks:
            system = [CCParticleFireworks node];
            break;
        case ParticleTypeFlower:
            system = [CCParticleFlower node];
            break;
        case ParticleTypeGalaxy:
            system = [CCParticleGalaxy node];
            break;
        case ParticleTypeMeteor:
            system = [CCParticleMeteor node];
            break;
            
        case ParticleTypeRain:
            system = [CCParticleRain node];
            break;
        case ParticleTypeSmoke:
            system = [CCParticleSmoke node];
            break;
        case ParticleTypeSnow:
            system = [CCParticleSnow node];
            break;
        case ParticleTypeSpiral:
            system = [CCParticleSpiral node];
            break;
        case ParticleTypeSun:
            system = [CCParticleSun node];
            break;
            
            // 使用自定义的plist效果
        case ParticleTypeDream:{
            system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"dream.plist"];
        }
            break;
            
        default:
            // 这里不运行任何代码
            break;
    }
    [self addChild: system z:-1 tag:1000];
}

@end
