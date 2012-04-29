//
//  SinglePlayerScene.m
//  Conquer
//
//  Created by Steve Johnson on 4/23/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "SinglePlayerScene.h"
#import "Map.h"
#import "Territory.h"

@implementation SinglePlayerScene

-(id) init
{
	if ((self = [super init]))
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];

		//setup the basic scene
		
		CCSprite* mapBackground = [CCSprite spriteWithFile:@"Maps/Background.png"];
		mapBackground.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:mapBackground z:-10];
		
		CCSprite* hud = [CCSprite spriteWithFile:@"HUD/SinglePlayer.png"];
		hud.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:hud z:10];
		
		
		map = [[Map alloc] initWithMapName:@"WorldMap1"];
		[self addChild:[map displayNode] z:-1];
		
		
		
		self.isTouchEnabled = true;
	}
	
	
	return self;
}










-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touch began!");
	// get the position in tile coordinates from the touch location
	[map territoryAtTouch:[touches anyObject]];
}

-(void) draw
{
    if([map selectedTerritory] != nil) {
        [[map selectedTerritory] highlight];
    }
}

@end
