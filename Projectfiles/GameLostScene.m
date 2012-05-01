//
//  GameLostScene.m
//  Conquer
//
//  Created by Stephen Johnson on 4/30/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import "GameLostScene.h"
#import "GameModeSelectionScene.h"

@implementation GameLostScene

-(id) init {
	if ((self = [super init])) {
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        
        // Create some menu items
        CCMenuItemImage * menuItem1 = [CCMenuItemImage itemFromNormalImage: [[NSBundle mainBundle] pathForResource:@"myfirstbutton" ofType:@"png" inDirectory:@"Buttons"]
                                                             selectedImage: [[NSBundle mainBundle] pathForResource:@"myfirstbutton_selected" ofType:@"png" inDirectory:@"Buttons"]
                                                                     block:^(id sender) {
																		 [[CCDirector sharedDirector] popScene];
                                                                     }
                                       ];
		
        
        
        // Create a menu and add your menu items to it
        CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, nil];
        
        // Arrange the menu items vertically
        [myMenu alignItemsVertically];
        
        
        // add the menu to your scene
		myMenu.position = ccp(winSize.width/2, winSize.height/2 + 100);
        [self addChild:myMenu];
        
        
        CCLabelTTF* gameLostLabel = [CCLabelTTF labelWithString:@"You Lost :(" fontName:@"Marker Felt" fontSize:48];
		gameLostLabel.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild: gameLostLabel];
        
        NSLog(@"GameLostScene created");
	}
	
	
	return self;
}

-(void) cleanup {
    
    NSLog(@"Cleaned up GameLostScene");
}

@end
