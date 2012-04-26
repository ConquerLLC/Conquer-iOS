//
//  Country.m
//  Conquer
//
//  Created by Steve Johnson on 4/25/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "Country.h"


@implementation Country


-(id)initWithCenter:(CGPoint)theCenter andColor:(UInt32)theColor {
	
	if((self = [super init])) {
		center = theCenter;
		color = theColor;
	}
	return self;
}


@end
