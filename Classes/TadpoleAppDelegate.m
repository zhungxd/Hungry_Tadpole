//
//  TadpoleAppDelegate.m
//  Tadpole
//
//  Created by 张晓东 on 11-4-11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "TadpoleAppDelegate.h"
#import "GameConfig.h"
#import "RootViewController.h"
#import "MainGame.h"
#import "MenuScene.h"
#import "OptionsScene.h"
#import "GameOverScene.h"
@implementation TadpoleAppDelegate

@synthesize window;


- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];


	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	[director setOpenGLView:glView];
	
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#endif

	[director setAnimationInterval:1.0/60];
//	[director setDisplayFPS:YES];
	
	
	[viewController setView:glView];
	
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:50];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"background.caf"];
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [MenuScene scene]];		
}

- (void)startGame {
	[[CCDirector sharedDirector] replaceScene:[MainGame scene]];
}

- (void)stopGame {
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:1.0f scene:[GameOverScene scene]]];
}
		
- (void)toMenu {
	[[CCDirector sharedDirector] replaceScene:[MenuScene scene]];
}

- (void)toOptions {
	[[CCDirector sharedDirector] replaceScene:[OptionsScene scene]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
