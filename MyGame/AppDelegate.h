//
//  AppDelegate.h
//  MyGame
//
//  Created by yfzx on 13-10-29.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property(nonatomic,retain) RootViewController	*viewController;
@property (nonatomic, retain) UIWindow *window;

@end
