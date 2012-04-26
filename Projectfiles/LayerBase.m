//
//  LayerBase.m
//  Conquer
//
//  Created by Steve Johnson on 4/23/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "LayerBase.h"

@implementation LayerBase

-(id) init
{
	if ((self = [super init]))
	{

	}
	
	return self;
}


+(id) scene {
	CCScene *scene = [CCScene node];
	id layer = [self node];
	[scene addChild: layer];
	return scene;
}

@end
