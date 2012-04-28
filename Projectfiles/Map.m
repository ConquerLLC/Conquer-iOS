//
//  Map.m
//  Conquer
//
//  Created by Steve Johnson on 4/25/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "Map.h"
#import "Territory.h"
#import "Continent.h"

@interface Map (PrivateAPI)
-(void)createHitMap;
-(CGPoint)toGridLocation:(CGPoint)location;
-(CGPoint)locationFromTouch:(UITouch*)touch;
-(UInt32)colorAtLocation:(CGPoint)location;
-(void)highlightTerritory:(Territory*)territory;
@end

@implementation Map


@synthesize size;
@synthesize gridSize;
@synthesize selectedTerritory;


-(id)initWithMapName:(NSString*)theMapName {
	
	if ((self = [super init])) {
		
		name = theMapName;		
		territoryWithColor = [[NSMutableDictionary alloc] init];
        locationsWithColor = [[NSMutableDictionary alloc] init];
		size = [[CCDirector sharedDirector] winSize];
		gridSize.width = (int)(size.width/GRID_SIZE);
		gridSize.height = (int)(size.height/GRID_SIZE);
        
        selectedTerritory = nil;

		//create the hitmap
		[self createHitMap];
		
		//load the specific map
		displayNode = [CCSprite spriteWithFile:[NSString stringWithFormat:@"Maps/%@/DisplayMap.png", name]];
		displayNode.position = ccp(size.width/2, size.height/2);
	}
	
	return self;
}

-(CCNode*)displayNode {
	return displayNode;
}

-(void)createHitMap {
	NSLog(@"Creating hitmap");
	
	UIImage *hitmapImage = [UIImage imageNamed:[NSString stringWithFormat:@"Maps/%@/HitMap.png", name]];
	
	int colorAtLocationSize = (gridSize.width*gridSize.height);
	NSLog(@"colorAtLocation size: %d, Grid size: %d", colorAtLocationSize, GRID_SIZE);

	short UInt32Size = sizeof(UInt32);
	NSLog(@"Size of UInt32: %d", UInt32Size);
	
	colorAtLocation = (UInt32*)malloc(colorAtLocationSize * UInt32Size);
	memset(colorAtLocation, 0, colorAtLocationSize * UInt32Size);
	
    imageData = CGDataProviderCopyData(CGImageGetDataProvider(hitmapImage.CGImage));
	const UInt32* pixels = (const UInt32*)CFDataGetBytePtr(imageData);
	int pixelsSize = size.width * size.height;
	
	int gridI;
	int y;
	int x;
	
	int gridX;
	int gridY;	
	
    NSMutableDictionary* colorCountMap = [[NSMutableDictionary alloc] init];
    
	NSLog(@"Mapping pixels to colors and territories...");
	for(int i = 0; i < pixelsSize; i++) {
		UInt32 pixel = pixels[i];
        NSNumber* colorKey = [NSNumber numberWithUnsignedInt:pixel];
        
        //get the number of times this color as been used
        NSNumber* colorCount = [colorCountMap objectForKey:colorKey];
        if(colorCount == nil) {
            colorCount = [NSNumber numberWithInt:0];
        }
        colorCount = [NSNumber numberWithInt:([colorCount intValue]+1)];
        [colorCountMap setObject:colorCount forKey:colorKey];
        
        if([colorCount intValue] == 50) {
            
            int r = (pixel)&0xFF;
            int g = (pixel>>8)&0xFF;
            int b = (pixel>>16)&0xFF;
            
            if(r == 0 && g == 0 && b == 255) {
                //ocean
            }else {
                //land!
                
                Territory* territory = [[Territory alloc] initWithColor:pixel onMap:self];
                [territoryWithColor setObject:territory forKey:colorKey];
                NSLog(@"Added territory for color key %@", colorKey);
            }
        }else {
            
        }
		
		//convert to x,y coords
		y = (i/size.width);
		x = i - (y*size.width);
		y = size.height-y;
		
		//map to grid coords
		gridX = x/GRID_SIZE;
		gridY = y/GRID_SIZE;
		if(gridY >= gridSize.height) gridY = gridSize.height-1;
		if(gridX >= gridSize.width) gridX = gridSize.width-1;
		gridI = (gridY * gridSize.width) + gridX;
		
		colorAtLocation[gridI] = pixel;        
	}
    
    NSLog(@"Determining territory pixels...");
    
    for(id colorKey in territoryWithColor) {
        Territory* territory = [territoryWithColor objectForKey:colorKey];
        UInt32 pixel = [colorKey unsignedIntValue];
        
        NSMutableArray* locations = [[NSMutableArray alloc] init];

        for(int i = 0; i < pixelsSize; i++) {
            if(pixels[i] == pixel) {
                //this pixel belongs to this territory
                [locations addObject:[NSNumber numberWithInt:i]];
            }
        }
    
        [territory setLocations:locations];
    }
	
	NSLog(@"Hitmap created");
}	

-(CGPoint)toGridLocation:(CGPoint)location {
	CGPoint gridLocation;
	gridLocation.x = (int)(location.x/GRID_SIZE);
	gridLocation.y = (int)(location.y/GRID_SIZE);
	NSLog(@"Converted %f,%f to grid %f,%f", location.x, location.y, gridLocation.x, gridLocation.y);
	return gridLocation;
}

-(UInt32)colorAtLocation:(CGPoint)location {
	CGPoint gridLocation = [self toGridLocation:location];
	int index = (int)(gridLocation.y * gridSize.width + gridLocation.x);
	NSLog(@"Grid location index: %d", index);
	return colorAtLocation[index];
}

-(CGPoint)locationFromTouch:(UITouch*)touch {
	CGPoint touchLocation = [touch locationInView:[touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

-(Territory*)territoryAtTouch:(UITouch*)touch {
	CGPoint location = [self locationFromTouch:touch];
	NSLog(@"Touch location %f,%f", location.x, location.y);
	return [self territoryAtLocation:location];
}

-(Territory*)territoryAtLocation:(CGPoint)location {
	UInt32 color = [self colorAtLocation:location];
	
	int r = (color)&0xFF;
	int g = (color>>8)&0xFF;
	int b = (color>>16)&0xFF;
	int a = (color>>24)&0xFF;
	
	NSLog(@"R=%d, G=%d, B=%d, A=%d at location %f,%f", r, g, b, a, location.x, location.y);
	
	NSNumber* colorKey = [NSNumber numberWithUnsignedInt:color];
	Territory* territory = [territoryWithColor objectForKey:colorKey];
	NSLog(@"Territory=%@", territory);
    selectedTerritory = territory;

	return territory;
}









-(void)dealloc {
    if(imageData != nil) {
        CFRelease(imageData);
    }
    if(colorAtLocation != nil) {
        free(colorAtLocation);
    }
}

@end
