//
//  TadpoleAppDelegate.h
//  Tadpole
//
//  Created by 张晓东 on 11-4-11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleAudioEngine.h"

@class RootViewController;

@interface TadpoleAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

- (void)startGame;
- (void)stopGame;
- (void)toMenu;
- (void)toOptions;

@end
