//
//  GameModeSelectionScene.m
//  Conquer
//
//  Created by Steve Johnson on 4/23/12.
//  Copyright 2012 ConquerCorp. All rights reserved.
//

#import "GameModeSelectionScene.h"

#import "TileMapLayer.h"


@implementation GameModeSelectionScene

-(id) init
{
	if ((self = [super init]))
	{
        // register to receive targeted touch events
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                         priority:0
                                                  swallowsTouches:YES];
        
        // Create some menu items
        CCMenuItemImage * menuItem1 = [CCMenuItemImage itemFromNormalImage: [[NSBundle mainBundle] pathForResource:@"myfirstbutton" ofType:@"png" inDirectory:@"Buttons"]
                                                             selectedImage: [[NSBundle mainBundle] pathForResource:@"myfirstbutton_selected" ofType:@"png" inDirectory:@"Buttons"]
                                                                     block:^(id sender) {
																		 [[CCDirector sharedDirector] pushScene:
                                                                          [CCTransitionFlipAngular transitionWithDuration:0.5f scene:[TileMapLayer scene]]];
                                                                     }
                                       ];
		
        
        
        // Create a menu and add your menu items to it
        CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, nil];
        
        id waves = [CCWaves actionWithWaves:5 amplitude:20 horizontal:YES vertical:NO grid:ccg(32,24) duration:5];
        CGSize size = [[CCDirector sharedDirector] winSize];
        id twirl = [CCTwirl actionWithPosition:ccp(size.width/2, size.height/2) twirls:1 amplitude:2.5f grid:ccg(12,8) duration:1];
        
        
        [myMenu runAction: [CCRepeatForever actionWithAction: waves]];
		
        // Arrange the menu items vertically
        [myMenu alignItemsVertically];
        
        // add the menu to your scene
        [self addChild:myMenu];
        

	}
	
	
	return self;
}



@end
