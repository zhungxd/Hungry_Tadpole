//
//  OptionsScene.m
//  Tadpole
//
//  Created by 张晓东 on 11-4-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OptionsScene.h"
#import "TadpoleAppDelegate.h"


@implementation OptionsScene
+(id) scene
{
	CCScene *scene = [CCScene node];
	OptionsScene *layer = [OptionsScene node];
	[scene addChild: layer];
	
	return scene;
}

- (id)init {
    
    if ((self = [super init])) {
		CCSprite *background = [CCSprite spriteWithFile:@"menu_bg.png" rect:CGRectMake(0, 0, 320, 480)];
		background.position = ccp(160,240);
		[self addChild:background];
		
		CCLabelTTF *musicLabel = [CCLabelTTF labelWithString:@"MUSIC" fontName:@"Arial" fontSize:28];
		
		[self addChild:musicLabel];
		[musicLabel setPosition:ccp(160,180)];
		
		CCLabelTTF *styleLabel = [CCLabelTTF labelWithString:@"GAME MODE" fontName:@"Arial" fontSize:28];
		
		[self addChild:styleLabel];
		[styleLabel setPosition:ccp(160,290)];

		CCMenuItemFont *on = [CCMenuItemFont itemFromString:@"ON"];
		CCMenuItemFont *off = [CCMenuItemFont itemFromString:@"OFF"];

		CCMenuItemToggle * music = [CCMenuItemToggle itemWithTarget:self selector:@selector(changeMusic:) items:on,off,nil];
		if ([[NSUserDefaults standardUserDefaults] boolForKey:@"music"]) {
			[music setSelectedIndex:1];
		}else {
			[music setSelectedIndex:0];
		}
		
		CCMenuItemFont *classic = [CCMenuItemFont itemFromString:@"CLASSIC"];
		CCMenuItemFont *ultimate = [CCMenuItemFont itemFromString:@"ULTIMATE"];
		
		CCMenuItemToggle *mode = [CCMenuItemToggle itemWithTarget:self selector:@selector(changeMode:) items:classic,ultimate,nil];
		if ([[NSUserDefaults standardUserDefaults] boolForKey:@"gamemode"]) {
			[mode setSelectedIndex:1];
		}else {
			[mode setSelectedIndex:0];
		}


		CCMenuItemImage *menu = [CCMenuItemImage itemFromNormalImage:@"menu.png" 
													   selectedImage:@"menu.png" 
															  target:self 
															selector:@selector(backtoMenu)];
		CCMenu *Menu = [CCMenu menuWithItems:mode, music, nil];
		[Menu setPosition:ccp(160,200)];
		[Menu alignItemsVerticallyWithPadding:75];
		[self addChild:Menu];
		
		CCMenu *MyMenu = [CCMenu menuWithItems:menu, nil];
		[MyMenu setPosition:ccp(100,50)];
		[self addChild:MyMenu];
	}
	
    return self;
    
}

- (void)changeMusic:(CCMenuItemToggle *)sender{
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	
	if(sender.selectedIndex ==1)
		[usrDef setBool:YES forKey:@"music"];
	if(sender.selectedIndex ==0)
		[usrDef setBool:NO forKey:@"music"];
}

- (void)changeMode:(CCMenuItemToggle *)sender{
	NSUserDefaults *usrDef = [NSUserDefaults standardUserDefaults];
	
	if(sender.selectedIndex ==1)
		[usrDef setBool:YES forKey:@"gamemode"];
	if(sender.selectedIndex ==0)
		[usrDef setBool:NO forKey:@"gamemode"];
}

- (void)backtoMenu {
	TadpoleAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate toMenu];
}

@end
