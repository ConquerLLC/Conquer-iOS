//
//  Territory.m
//  Conquer
//
//  Created by Steve Johnson on 4/25/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "Territory.h"
#import "Map.h"
#import "Continent.h"
#import "Player.h"
#import "cocos2d.h"


@implementation Territory

@synthesize name;
@synthesize center;
@synthesize owner;
@synthesize armies;

-(id)initWithColor:(UInt32)theColor name:(NSString*)theName onContinent:(Continent*)theContinent onMap:(Map*)theMap {
	
	if((self = [super init])) {
		color = theColor;
        name = theName;
        map = theMap;
        continent = theContinent;
        locations = [[NSArray alloc] init];
        borderLocations = [[NSArray alloc] init];
        neighboringTerritories = [[NSArray alloc] init];
        owner = nil;
        NSLog(@"Created territory %@ on continent %@", name, continent.name);
	}
	return self;
}

-(void)setNeighboringTerritories:(NSArray*)theNeighboringTerritories {
    neighboringTerritories = theNeighboringTerritories;
}

-(void)setLocations:(NSArray*)theLocations {
    locations = theLocations;
    
    int locationsSize = [locations count];
    UInt32 xSum = 0;
    UInt32 ySum = 0;
    NSLog(@"Finding center for territory %@, color=%lu, pixelCount=%d", name, color, locationsSize);
    for(int i = 0; i < locationsSize; i++) {
        NSNumber* locationN = [locations objectAtIndex:i];
        int location = [locationN intValue];
        
        //convert to x,y coords
        int y = (location/[map size].width);
        int x = location - (y*[map size].width);
        y = [map size].height-y;
        
        xSum+= x;
        ySum+= y;
    }
    
    //convert to x,y coords       
    center.x = xSum/locationsSize;
    center.y = ySum/locationsSize;
    NSLog(@"Center: %d,%d", (int)center.x, (int)center.y);
    
    //TEMP!
    borderLocations = locations;
}

-(NSArray*)locations {
    return locations;
}

-(NSArray*)borderLocations {
    return borderLocations;
}


-(void)highlight:(UInt32)highlightColor {
    
    UInt8 red = (highlightColor) & 0xFF;
    UInt8 green = (highlightColor>>8) & 0xFF;
    UInt8 blue = (highlightColor>>16) & 0xFF;
    UInt8 alpha = (highlightColor>>24) & 0xFF;
    
    glLineWidth(3);
    
    int borderLocationsSize = [borderLocations count];
	
	CGPoint* vertices = (CGPoint*)malloc(borderLocationsSize * sizeof(CGPoint));
	memset(vertices, 0, borderLocationsSize * sizeof(CGPoint));
    
    for(int i = 0; i < borderLocationsSize; i++) {
        NSNumber* locationN = [borderLocations objectAtIndex:i];
        int location = [locationN intValue];
        
        //convert to x,y coords
        int y = (location/[map size].width);
        int x = location - (y*[map size].width);
        y = [map size].height-y;
                
        vertices[i] = ccp(x,y);
    }   
    
    glColor4ub(red, green, blue, alpha);
    ccDrawPoly(vertices, borderLocationsSize, YES);
        
    free(vertices);
}

-(void)dealloc {
    
    NSLog(@"Territory %@ deallocated", name);
}

@end
