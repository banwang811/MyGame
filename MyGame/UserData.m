//
//  UserData.m
//  MyGame
//
//  Created by yfzx on 13-11-6.
//
//

#import "UserData.h"

@implementation UserData

@synthesize heroType;
@synthesize lev;
@synthesize hpNow;
@synthesize mpNow;
@synthesize exp;
@synthesize procession;
@synthesize map;
//@synthesize bgsound;
//@synthesize sound;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:heroType forKey:@"heroType"];
    [aCoder encodeInt:lev forKey:@"lev"];
    [aCoder encodeInt:hpNow forKey:@"hpNow"];
    [aCoder encodeInt:mpNow forKey:@"mpNow"];
    [aCoder encodeInt:exp forKey:@"exp"];
    [aCoder encodeInt:procession forKey:@"procession"];
    [aCoder encodeInt:map forKey:@"map"];
//    [aCoder encodeBool:bgsound forKey:@"bgsound"];
//    [aCoder encodeBool:sound forKey:@"sound"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.heroType = [aDecoder decodeIntegerForKey:@"heroType"];
        self.lev = [aDecoder decodeIntegerForKey:@"lev"];
        self.hpNow = [aDecoder decodeIntegerForKey:@"hpNow"];
        self.mpNow = [aDecoder decodeIntegerForKey:@"mpNow"];
        self.exp = [aDecoder decodeIntegerForKey:@"exp"];
        self.procession = [aDecoder decodeIntegerForKey:@"procession"];
        self.map = [aDecoder decodeIntegerForKey:@"map"];
//        self.bgsound = [aDecoder decodeBoolForKey:@"bgsound"];
//        self.sound = [aDecoder decodeBoolForKey:@"sound"];
    }
    return self;
}

@end
