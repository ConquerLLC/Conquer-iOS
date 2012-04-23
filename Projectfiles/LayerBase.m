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

/* By default - a layer does not handle touches */
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return NO;
}

@end
