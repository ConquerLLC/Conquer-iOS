//
//  SceneBase.m
//  Conquer
//
//  Created by Steve Johnson on 4/23/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "SceneBase.h"

@implementation SceneBase

-(id) init
{
	if ((self = [super init]))
	{

	}
	
	return self;
}

/* By default - a scene does not handle touches */
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return NO;
}

+(id) scene {
	CCScene *scene = [CCScene node];
	id layer = [self node];
	[scene addChild: layer];
	return scene;
}

@end
