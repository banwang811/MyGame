//
//  SelectScene.m
//  FirstGame
//
//  Created by yfzx on 13-10-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "SelectScene.h"
#import "CCScrollLayer.h"
#import "Mission1Scene.h"


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
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    for (int i=1; i < 5; i++) {
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
                addr = @"迷雾森林";
                break;
                
            case 2:
                addr = @"死亡之谷";
                break;
                
            case 3:
                addr = @"血战沙场";
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
    
    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.2f scene:[Mission1Scene scene]]];
    
}

@end
