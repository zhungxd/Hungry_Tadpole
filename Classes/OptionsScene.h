//
//  OptionsScene.h
//  Tadpole
//
//  Created by 张晓东 on 11-4-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface OptionsScene : CCLayer {

}
+(id) scene;
- (void)backtoMenu;
- (void)changeMusic:(CCMenuItemToggle *)sender;
- (void)changeMode:(CCMenuItemToggle *)sender;

@end
