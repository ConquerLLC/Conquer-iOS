//
//  Map.m
//  Conquer
//
//  Created by Steve Johnson on 4/25/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "Map.h"

@interface Map (PrivateAPI)
-(void)createHitMap;
-(CGPoint)toGridLocation:(CGPoint)location;
-(CGPoint)locationFromTouch:(UITouch*)touch;
-(UInt32)colorAtLocation:(CGPoint)location;
@end

@implementation Map


-(id)initWithMapName:(NSString*)theMapName {
	
	if ((self = [super init])) {
		
		name = theMapName;		
		countries = [[NSMutableDictionary alloc] init];
		size = [[CCDirector sharedDirector] winSize];
		gridSize.width = (int)(size.width/GRID_SIZE);
		gridSize.height = (int)(size.height/GRID_SIZE);

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
	
	int hitmapSize = (gridSize.width*gridSize.height);
	NSLog(@"Hitmap size: %d, Grid size: %d", hitmapSize, GRID_SIZE);

	short UInt32Size = sizeof(UInt32);
	NSLog(@"Size of UInt32: %d", UInt32Size);
	
	hitMap = (UInt32*)malloc(hitmapSize * UInt32Size);
	memset(hitMap, 0, hitmapSize);
	
	CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(hitmapImage.CGImage));
	const UInt32* pixels = (const UInt32*)CFDataGetBytePtr(imageData);
	int pixelsSize = size.width * size.height;
	
	int gridI;
	int y;
	int x;
	
	int gridX;
	int gridY;	
	
	
	for(int i = 0; i < pixelsSize; i++) {
		UInt32 pixel = pixels[i];
		
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
		
		hitMap[gridI] = pixel;
	}
	CFRelease(imageData);
	
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
	return hitMap[index];
}

-(CGPoint)locationFromTouch:(UITouch*)touch {
	CGPoint touchLocation = [touch locationInView:[touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

-(Country*)countryAtTouch:(UITouch*)touch {
	CGPoint location = [self locationFromTouch:touch];
	NSLog(@"Touch location %f,%f", location.x, location.y);
	return [self countryAtLocation:location];
}

-(Country*)countryAtLocation:(CGPoint)location {
	UInt32 color = [self colorAtLocation:location];
	
	int r = (color)&0xFF;
	int g = (color>>8)&0xFF;
	int b = (color>>16)&0xFF;
	int a = (color>>24)&0xFF;
	
	NSLog(@"R=%d, G=%d, B=%d, A=%d at location %f,%f", r, g, b, a, location.x, location.y);

	if(r == 0 && g == 0 && b > 0) {
		[[[UIAlertView alloc] initWithTitle:@"Conquer" message:@"Water!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	}else if(r > 200 && g < 100 && b < 100) {
		[[[UIAlertView alloc] initWithTitle:@"Conquer" message:@"Red!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	}else if(r > 100 && b < 100 && g > 100) {
		[[[UIAlertView alloc] initWithTitle:@"Conquer" message:@"Yellow!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	}else if(r > 100 && g == 0 && b > 100) {
		[[[UIAlertView alloc] initWithTitle:@"Conquer" message:@"Purple!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	}
	
	NSNumber* locationKey = [NSNumber numberWithInt:color];
	Country* country = [countries objectForKey:locationKey];
	NSLog(@"Country=%@", country);

	return country;
}

@end
