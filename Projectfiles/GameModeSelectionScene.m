//
//  GameModeSelectionScene.m
//  Conquer
//
//  Created by Steve Johnson on 4/23/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "GameModeSelectionScene.h"

#import "SinglePlayerScene.h"


@implementation GameModeSelectionScene

-(id) init
{
	if ((self = [super init]))
	{
        // Create some menu items
        CCMenuItemImage * menuItem1 = [CCMenuItemImage itemFromNormalImage: [[NSBundle mainBundle] pathForResource:@"myfirstbutton" ofType:@"png" inDirectory:@"Buttons"]
                                                             selectedImage: [[NSBundle mainBundle] pathForResource:@"myfirstbutton_selected" ofType:@"png" inDirectory:@"Buttons"]
                                                                     block:^(id sender) {
																		 [[CCDirector sharedDirector] pushScene:
                                                                          [CCTransitionFlipAngular transitionWithDuration:0.5f scene:[SinglePlayerScene scene]]];
                                                                     }
                                       ];
		
        
        
        // Create a menu and add your menu items to it
        CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, nil];
        
        id waves = [CCWaves actionWithWaves:5 amplitude:20 horizontal:YES vertical:NO grid:ccg(32,24) duration:5];        
        [myMenu runAction: [CCRepeatForever actionWithAction: waves]];
		
        // Arrange the menu items vertically
        [myMenu alignItemsVertically];
        
        // add the menu to your scene
        [self addChild:myMenu];
        

	}
	
	
	return self;
}

@end
