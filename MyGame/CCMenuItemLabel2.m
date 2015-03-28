//
//  CCMenuItemLabel2.m
//  MyGame
//
//  Created by yfzx on 13-10-31.
//
//

#import "CCMenuItemLabel2.h"

@implementation CCMenuItemLabel2

@synthesize skillIcon;
@synthesize skillName;
@synthesize skillDescription;

-(void)dealloc{
    
    if (skillIcon) {
        [skillIcon release];
    }
    
    if (skillName) {
        [skillName release];
    }
    
    if (skillDescription) {
        [skillDescription release];
    }
    
    [super dealloc];
}

@end
