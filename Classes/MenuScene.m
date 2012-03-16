//
//  MenuScene.m
//  Tadpole
//
//  Created by 张晓东 on 11-4-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "TadpoleAppDelegate.h"


@implementation MenuScene
+(id) scene
{
	CCScene *scene = [CCScene node];
	MenuScene *layer = [MenuScene node];
	[scene addChild: layer];
	
	return scene;
}

- (id)init {
    
    if ((self = [super init])) {
		CCSprite *background = [CCSprite spriteWithFile:@"menu_bg.png" rect:CGRectMake(0, 0, 320, 480)];
		background.position = ccp(160,240);
		[self addChild:background];
		
		CCSpriteBatchNode *_batchNode = [CCSpriteBatchNode batchNodeWithFile:@"enemy.png" capacity:10];
		for (int i =0; i<2; i++) {
			CCSprite *tadpole = [CCSprite spriteWithBatchNode:_batchNode rect:CGRectMake(0, 0, 33, 48)];
			tadpole.position = ccp(80*i+220,480+tadpole.contentSize.height/2);
			tadpole.scale = -1;
			[_batchNode addChild:tadpole];
			[tadpole runAction:[CCRepeatForever actionWithAction:
								[CCSequence actions:
								 [CCMoveTo actionWithDuration:5-i position:ccp(80*i+220,0-tadpole.contentSize.height/2)],
								 [CCPlace actionWithPosition:ccp(80*i+220,480+tadpole.contentSize.height/2)],nil]]];
		}
		[self addChild:_batchNode];
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player1.png"];
		CCSpriteFrame *frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player2.png"];
		CCSprite *_players = [CCSprite spriteWithSpriteFrameName:@"player1.png"];

		_players.position = ccp(80,320);
		[self addChild:_players];

		NSMutableArray *animFrames = [NSMutableArray arrayWithObjects:frame, frame1 ,nil];

		CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:0.2f];
		[_players runAction:[CCRepeatForever actionWithAction: 
							 [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]]];
								 
		CCMenuItemImage *menu_play = [CCMenuItemImage itemFromNormalImage:@"play_game.png" 
															selectedImage:@"play_game.png" 
																   target:self 
																 selector:@selector(play_game)];
		
		CCMenuItemImage *menu_options = [CCMenuItemImage itemFromNormalImage:@"options.png" 
															selectedImage:@"options.png" 
																   target:self 
																 selector:@selector(go_options)];

		menu_play.scale = 0.8;
		menu_options.scale = 0.8;
		
		CCMenu *MyMenu = [CCMenu menuWithItems:menu_play, menu_options , nil];
		
		[MyMenu alignItemsVerticallyWithPadding:30];
		MyMenu.position = ccp(160,200);
		[self addChild:MyMenu];
	}
		
		
    return self;
    
}

- (void)play_game {
	TadpoleAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate startGame];
}

- (void)go_options {
	TadpoleAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate toOptions];
}

-(void) dealloc
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[super dealloc];
}

@end
