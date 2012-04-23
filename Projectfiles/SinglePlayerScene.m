//
//  GameModeSelectionScene.m
//  Conquer
//
//  Created by Steve Johnson on 4/23/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "SinglePlayerScene.h"

#import "TileMapLayer.h"


@implementation SinglePlayerScene

-(id) init
{
	if ((self = [super init]))
	{
		TileMapLayer* tileMapLayer = [TileMapLayer node];
		[self addChild:tileMapLayer z:0];
		
		
		CCSprite* hud = [CCSprite spriteWithFile:@"HUD/GameHUD.png"];
		hud.position = ccp(512,384);
		[self addChild:hud z:1];
	}
	
	
	return self;
}



@end
