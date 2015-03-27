//
//  Lottery.m
//  FirstGame
//
//  Created by yfzx on 13-10-28.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Lottery.h"


@implementation Lottery

@synthesize msg,fname,max,min;

-(void)dealloc{
    [msg release];
    [fname release];
    [super dealloc];
}

+(Lottery *)lottery:(NSString *)name andMsg:(NSString *)content{
    Lottery *lt = [Lottery spriteWithFile:name];
    lt.fname = name;
    lt.msg = content;
    return lt;
}


@end
