//
//  GameModeSelectionScene.m
//  Conquer-iOS
//
//  Created by Steve Johnson on 4/19/12.
//  Copyright ConquerCorp 2012. All rights reserved.
//


// Import the interfaces
#import "GameModeSelectionScene.h"
#import "CCTouchDispatcher.h"
#import "HelloWorldLayer.h"

// GameModeSelectionScene implementation
@implementation GameModeSelectionScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameModeSelectionScene *layer = [GameModeSelectionScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		       
        self.isTouchEnabled = YES;
        
        // register to receive targeted touch events
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                         priority:0
                                                  swallowsTouches:YES];
        
        // Create some menu items
        CCMenuItemImage * menuItem1 = [CCMenuItemImage itemFromNormalImage: [[NSBundle mainBundle] pathForResource:@"myfirstbutton" ofType:@"png" inDirectory:@"Buttons"]
                                                             selectedImage: [[NSBundle mainBundle] pathForResource:@"myfirstbutton_selected" ofType:@"png" inDirectory:@"Buttons"]
                                                                     block:^(id sender) {
                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                             [[CCDirector sharedDirector] replaceScene:
                                                                          [CCTransitionFade transitionWithDuration:0.5f scene:[HelloWorldLayer scene]]];
                                                                         });
                                                                     }
                                       ];
        
        
        
        // Create a menu and add your menu items to it
        CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, nil];
        
        // Arrange the menu items vertically
        [myMenu alignItemsVertically];
        
        // add the menu to your scene
        [self addChild:myMenu];
        
    }
    
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	cpSpaceFree(space);
	space = NULL;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) onEnter
{
	[super onEnter];
}


@end
