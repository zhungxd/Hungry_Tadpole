//
//  GameOverScene.m
//  Tadpole
//
//  Created by 张晓东 on 11-4-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameOverScene.h"
#import "TadpoleAppDelegate.h"


@implementation GameOverScene
+(id) scene
{
	CCScene *scene = [CCScene node];
	GameOverScene *layer = [GameOverScene node];
	[scene addChild: layer];
	
	return scene;
}

- (id)init {
    
    if ((self = [super init])) {
		CCSprite *background = [CCSprite spriteWithFile:@"game_bg.png" rect:CGRectMake(0, 0, 320, 480)];
		background.position = ccp(160,240);
		[self addChild:background];
		CCLabelTTF *title = [CCLabelTTF labelWithString:@"YOUR SCORE" fontName:@"Arial" fontSize:28];
		title.position = ccp(160,420);
		[self addChild:title];
		
		NSString *_lasts = [[NSString alloc] initWithFormat:@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"lastscores"]];
		NSString *_highs = [[NSString alloc] initWithFormat:@"HIGHSCORE:   %d",[[NSUserDefaults standardUserDefaults] integerForKey:@"highscores"]];
		
	    CCLabelTTF *lastscores = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:42];
		lastscores.position = ccp(160,350);
		[self addChild:lastscores];
		
		[lastscores setString:_lasts];
		id a1 = [CCScaleTo actionWithDuration:0.2f scaleX:1.5f scaleY:0.8f];
		id a2 = [CCScaleTo actionWithDuration:0.2f scaleX:1.0f scaleY:1.0f];
		id a3 = [CCSequence actions:a1,a2,a1,a2,a1,a2,nil];
		[lastscores runAction:a3];
		
	    CCLabelTTF *highscores = [CCLabelTTF labelWithString:_highs fontName:@"Arial" fontSize:30];
		highscores.position = ccp(160,240);
		[self addChild:highscores];
		
		[_lasts release];
		[_highs release];
		CCMenuItemImage *menu = [CCMenuItemImage itemFromNormalImage:@"menu.png" 
													   selectedImage:@"menu.png" 
															  target:self 
															selector:@selector(backtoMenu)];
		CCMenuItemImage *menu_restart = [CCMenuItemImage itemFromNormalImage:@"restart.png" 
													   selectedImage:@"restart.png" 
															  target:self 
															selector:@selector(restartGame)];
		
		CCMenu *MyMenu = [CCMenu menuWithItems:menu,menu_restart,nil];
		[MyMenu alignItemsHorizontallyWithPadding:10];
		MyMenu.position = ccp(160,100);
		[self addChild:MyMenu];
    }
    return self;
    
}

- (void)restartGame {
	TadpoleAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate startGame];
}

- (void)backtoMenu {
	TadpoleAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate toMenu];
}

@end
