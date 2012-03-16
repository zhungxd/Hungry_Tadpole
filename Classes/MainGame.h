//
//  MainGame.h
//  tweejump
//
//  Created by 张晓东 on 11-4-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#define FPS                60
#define TADPOLE_WIDTH      30
#define TADPOLE_HEIGHT     43
#define ENEMY_WIDTH        33
#define ENEMY_HEIGHT       48

enum {
	kSptiteBatchNode,
	kTadpole,
	kEnemy,
	kScoreLabel,
};

@interface MainGame : CCLayer {
	CGPoint Tadpole_pos;
	CGPoint Tadpole_vel;
	CGPoint Tadpole_acc;
	
	NSMutableArray *_enemy;
	CCSpriteBatchNode *spriteBatchNode;
	
	int score;
	int gamemode;
	float difficultLevel;
	
	bool isGameover;
}

@property (nonatomic, retain) CCSpriteBatchNode *spriteBatchNode;
@property (nonatomic, retain) NSMutableArray *_enemy;

+(id) scene;

@end
