//
//  Territory.m
//  Conquer
//
//  Created by Steve Johnson on 4/25/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "Territory.h"
#import "Map.h"


@implementation Territory


-(id)initWithColor:(UInt32)theColor onMap:(Map*)theMap {
	
	if((self = [super init])) {
		color = theColor;
        map = theMap;
        locations = [[NSArray alloc] init];
	}
	return self;
}

-(void)setLocations:(NSArray*)theLocations {
    locations = theLocations;
    
    int locationsSize = [locations count];
    NSLog(@"Finding center for territory %@, pixelCount=%d", self, locationsSize);
    for(int i = 0; i < locationsSize; i++) {
        NSNumber* locationN = [locations objectAtIndex:i];
        int location = [locationN intValue];
        
        //convert to x,y coords
        int y = (location/[map size].width);
        int x = location - (y*[map size].width);
        y = [map size].height-y;
        
        //NSLog(@"%d, %f, %f, %d,%d", location, [map size].width, [map size].height, x, y);
        
        //TODO: set center!
    }
}

-(NSArray*)locations {
    return locations;
}

-(void)highlight {
    
    int locationsSize = [locations count];

    for(int i = 0; i < locationsSize; i++) {
        NSNumber* locationN = [locations objectAtIndex:i];
        int location = [locationN intValue];
        
        //convert to x,y coords
        int y = (location/[map size].width);
        int x = location - (y*[map size].width);
        y = [map size].height-y;
        
        
        glLineWidth(3);
        glColor4ub(0, 255, 255, 255);
        ccDrawCircle(ccp(x,y), 4, CC_DEGREES_TO_RADIANS(90), 40, NO);
    }    
}

@end
