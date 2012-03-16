//
//  MainGame.m
//  tweejump
//
//  Created by 张晓东 on 11-4-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainGame.h"
#import "TadpoleAppDelegate.h"

@interface MainGame (Private)
- (void)startGame;
- (void)initBackground;
- (void)addscore;
- (void)addEnemy;
- (void)spriteMoveFinished:(id)sender;
- (void)resetTadpole;
- (void)step:(ccTime)dt;
- (void)uploadlastscores:(int)lastscores;
- (int)loadHighscores;
- (void)updateHighscores:(int)highscores;
- (void)saveHighscores:(int)highscores;
@end

@implementation MainGame
@synthesize spriteBatchNode, _enemy;

+(id) scene
{
	CCScene *scene = [CCScene node];
	MainGame *layer = [MainGame node];
	[scene addChild: layer];
	
	return scene;
}

- (id)init {
	
	if(![super init]) return nil;
	
	isTouchEnabled_ = NO;
	isAccelerometerEnabled_ = YES;
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / FPS)];
	
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"music"]) {
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.caf" loop:YES];
	}
	
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"gamemode"]) {
		gamemode = 1;
	}else {
		gamemode = 2;
	}

	
	self._enemy = [[[NSMutableArray alloc] init] autorelease];

	[self initBackground];
	
	spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"enemy.png" capacity:30];
	[self addChild:spriteBatchNode z:4 tag:kSptiteBatchNode];
	
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player.plist"];
	
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player1.png"];
	CCSpriteFrame *frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player2.png"];
	CCSprite *Tadpole = [CCSprite spriteWithSpriteFrameName:@"player1.png"];
		
	NSMutableArray *animFrames = [NSMutableArray arrayWithObjects:frame, frame1 ,nil];
	
	CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:0.2f];
	[Tadpole runAction:[CCRepeatForever actionWithAction: 
						 [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]]];
		
	[self addChild:Tadpole z:3 tag:kTadpole];
	
	
	NSString *_score = [NSString stringWithFormat:@"BEST:%d",[self loadHighscores]];
	
	CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"bitmapFont.fnt"];
	[self addChild:scoreLabel z:5 tag:kScoreLabel];
	scoreLabel.position = ccp(280,465);
	
	CCLabelTTF *highscoreLabel = [CCLabelTTF labelWithString:_score fontName:@"Arial" fontSize:12];
	[self addChild:highscoreLabel z:5];
	highscoreLabel.position = ccp(280,450);
	
	[self schedule:@selector(step:)];
		
	[self startGame];
	
	return self;
}

- (void)initBackground{
	CCSprite *background = [CCSprite spriteWithFile:@"game_bg.png" rect:CGRectMake(0, 0, 320, 480)];
	background.position = ccp(160,240);
//	id a1 = [CCMoveTo actionWithDuration:10 position:ccp(160,-240)];
//	id a2 = [CCMoveTo actionWithDuration:20 position:ccp(160,-240)];
//	id a3 = [CCPlace actionWithPosition:ccp(160,720)];
//	id a4 = [CCRepeatForever actionWithAction:[CCSequence actions:a2,a3,nil]];
//
//	[background runAction:[CCRepeatForever actionWithAction:[CCSequence actions:a1,a3,nil]]];
//	 
//	CCSprite *background2 = [CCSprite spriteWithFile:@"game_bg.png" rect:CGRectMake(0, 0, 320, 480)];
//	background2.position = ccp(160,720);
//	
//   [background2 runAction:[CCRepeatForever actionWithAction:[CCSequence actions:a2,a3,nil]]];
//	
//	[self addChild:background];
//	[self addChild:background2];
	[self addChild:background];
		  
}

- (void)startGame{
	score = 0 ;
	difficultLevel = 1.0;
	isGameover = NO;
	
	[self resetTadpole];
	[self schedule:@selector(addscore) interval:0.1];

	if (gamemode == 1) {
		[self schedule:@selector(addEnemy) interval:0.5];
	}else {
		[self schedule:@selector(addEnemy) interval:0.8];
	}

}

- (void)addscore{
	score = score + 1 * difficultLevel * gamemode;
}

- (void)addEnemy{
	CCSprite *Enemy = [CCSprite spriteWithBatchNode:spriteBatchNode rect:CGRectMake(0,0,ENEMY_WIDTH,ENEMY_HEIGHT)];

	int minX = Enemy.contentSize.width/2;
	int maxX = 320 - Enemy.contentSize.width/2;
	int rangeX = maxX - minX;
	int actualX = (arc4random() % rangeX) + minX;

	Enemy.position = ccp(actualX, 480 + (Enemy.contentSize.height/2));
	
	[spriteBatchNode addChild:Enemy z:4 tag:kEnemy];
		
	int minDuration = 5;
	int maxDuration = 9;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	float _dur = actualDuration / difficultLevel;

	if (gamemode == 2) {
		_dur = _dur / 2.5-0.3;
		
		if (arc4random() % 10 < 7) {
			actualX = Tadpole_pos.x;
		}
	}
	
	[Enemy runAction:[CCSequence actions:
					  [CCMoveTo actionWithDuration:_dur 
										  position:ccp(actualX, -Enemy.contentSize.height/2)], 
					  [CCCallFuncN actionWithTarget:self 
										  selector:@selector(spriteMoveFinished:)], nil]];
	
	[_enemy addObject:Enemy];

}

- (void)spriteMoveFinished:(CCSprite *)sender{
	[spriteBatchNode removeChild:sender cleanup:YES];
	
	[_enemy removeObject:sender];
	
	score = score + 10 * difficultLevel * gamemode;

}
						 
- (void)resetTadpole{
	CCSprite *Tadpole = (CCSprite*)[self getChildByTag:kTadpole];
	
	Tadpole_pos.x = 160;
	Tadpole_pos.y = 40;
	Tadpole.position = Tadpole_pos;
	
	Tadpole_vel.x = 0;
	Tadpole_vel.y = 0;
	
	Tadpole_acc.x = 0;
	Tadpole_acc.y = 0;
	
	Tadpole.scaleX = 1.0f;
}

- (void)step:(ccTime)dt{
	if (isGameover) {
		return;
	}
	
	difficultLevel = score /8000 + 1;
	if (difficultLevel > 2.5) {
		difficultLevel = 2.5;
	}
	
	CCSprite *Tadpole = (CCSprite*)[self getChildByTag:kTadpole];	
	
	Tadpole_pos.x += Tadpole_vel.x * dt;
	Tadpole_pos.y += Tadpole_vel.y * dt;

	CGSize Tadpole_size = Tadpole.contentSize;
	float max_x = 320-Tadpole_size.width/2;
	float min_x = 0+Tadpole_size.width/2;
	float max_y = 640-Tadpole_size.height/2;
	float min_y = 0+Tadpole_size.height/2;
	
	if(Tadpole_pos.x>max_x) Tadpole_pos.x = max_x;
	if(Tadpole_pos.x<min_x) Tadpole_pos.x = min_x;
	if(Tadpole_pos.y>max_y) Tadpole_pos.y = max_y;
	if(Tadpole_pos.y<min_y) Tadpole_pos.y = min_y;
	
	for (CCSprite *enemy in _enemy) {
		if (ccpDistance(Tadpole.position, enemy.position)<28) {
			isGameover = YES;
			[self updateHighscores:score];
			[self uploadlastscores:score];
			
			if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
				[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
			}
			TadpoleAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			[delegate stopGame];
		}
	}
	
	NSString *scoreStr = [NSString stringWithFormat:@"%d",score];
	CCLabelBMFont *scoreLabel = (CCLabelBMFont*)[self getChildByTag:kScoreLabel];
	[scoreLabel setString:scoreStr];
	id a1 = [CCScaleTo actionWithDuration:0.2f scaleX:1.5f scaleY:0.8f];
	id a2 = [CCScaleTo actionWithDuration:0.2f scaleX:1.0f scaleY:1.0f];
	id a3 = [CCSequence actions:a1,a2,a1,a2,a1,a2,nil];
	[scoreLabel runAction:a3];
	
	Tadpole.position = Tadpole_pos;
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	float accel_filter = 0.1f;
	Tadpole_vel.x = Tadpole_vel.x * accel_filter + acceleration.x * (1.0f - accel_filter) * 500.0f;
	Tadpole_vel.y = Tadpole_vel.y * accel_filter + acceleration.y * (1.0f - accel_filter) * 500.0f;

}

- (void)uploadlastscores:(int)lastscores{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *scores = [NSNumber numberWithInt:lastscores];
	[defaults setObject:scores forKey:@"lastscores"];
}

- (int)loadHighscores {
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSNumber *scores = [defaults valueForKey:@"highscores"];
	if (scores) {
		return [scores intValue];
	}else {
		return 0;
	}
}

- (void)updateHighscores:(int)highscores{
	if (highscores>[self loadHighscores]) {
		[self saveHighscores:highscores];
	}
}

- (void)saveHighscores:(int)highscores {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *scores = [NSNumber numberWithInt:highscores];
	[defaults setObject:scores forKey:@"highscores"];
}

- (void)dealloc {
	[_enemy release];
	[super dealloc];
}

@end
