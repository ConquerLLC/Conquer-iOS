//
//  Map.m
//  Conquer
//
//  Created by Steve Johnson on 4/25/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "Constants.h"
#import "Map.h"
#import "Territory.h"
#import "Continent.h"
#import "CGImageInspection.h"
#import "CJSONDeserializer.h"


@interface Map (PrivateAPI)
-(void)initializeMapData;
-(CGPoint)toGridLocation:(CGPoint)location;
-(CGPoint)locationFromTouch:(UITouch*)touch;
-(UInt32)colorAtLocation:(CGPoint)location;
-(void)highlightTerritory:(Territory*)territory;
@end

@implementation Map


@synthesize size;
@synthesize gridSize;
@synthesize properties;


-(id)initWithMapName:(NSString*)theMapName {
	
	if ((self = [super init])) {
		
		name = theMapName;		
		territoryWithColor = [[NSMutableDictionary alloc] init];
        locationsWithColor = [[NSMutableDictionary alloc] init];
		size = [[CCDirector sharedDirector] winSize];
		gridSize.width = (int)(size.width/GRID_SIZE);
		gridSize.height = (int)(size.height/GRID_SIZE);
        
		//create the hitmap and load map properties
		[self initializeMapData];
		
		//load the specific map
		displayNode = [CCSprite spriteWithFile:[NSString stringWithFormat:@"Maps/%@/DisplayMap.png", name]];
		displayNode.position = ccp(size.width/2, size.height/2);
	}
	
	return self;
}

-(CCNode*)displayNode {
	return displayNode;
}

-(void)initializeMapData {
	
    NSLog(@"Loading map properties");
    
    NSData *jsonData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"Maps/%@/Properties.json", name]];
    NSError *error = nil;
    properties = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
    if(properties == nil) {
        NSLog(@"Failed to map properties file. Error=%@", error);
    }
    NSDictionary* territoryInfoMap = [properties objectForKey:@"Territories"];
    
    NSLog(@"Creating hitmap");
	
	UIImage *hitmapImage = [UIImage imageNamed:[NSString stringWithFormat:@"Maps/%@/HitMap.png", name]];
	
	int colorAtLocationSize = (gridSize.width*gridSize.height);
	NSLog(@"colorAtLocation size: %d, Grid size: %d", colorAtLocationSize, GRID_SIZE);

	short UInt32Size = sizeof(UInt32);
	NSLog(@"Size of UInt32: %d", UInt32Size);
	
	colorAtLocation = (UInt32*)malloc(colorAtLocationSize * UInt32Size);
	memset(colorAtLocation, 0, colorAtLocationSize * UInt32Size);
    
    imageInspector = [CGImageInspection imageInspectionWithCGImage:hitmapImage.CGImage];
	
    UInt32 pixel;
    UInt8 red;
    UInt8 green;
    UInt8 blue;
    UInt8 alpha;
    
	int gridI;
	int gridX;
	int gridY;	
	
    NSMutableDictionary* colorCountMap = [[NSMutableDictionary alloc] init];
    
    int pixelCount = size.width*size.height;
	NSLog(@"Mapping pixels to colors and territories (examining %d pixels)...", pixelCount);
	for(int x = 0; x < size.width; x++) {
        for(int y = 0; y < size.height; y++) {
            
            [imageInspector colorAt:(CGPoint){x, size.height-y} 
                                red:&red 
                                green:&green 
                                blue:&blue 
                                alpha:&alpha 
                                pixel:&pixel];  
           
            //NSLog(@"R=%d, G=%d, B=%d, pixel=%lu at location %d,%d", red, green, blue, pixel, x, y);
            
            NSNumber* colorKey = [NSNumber numberWithUnsignedInt:pixel];
            
            //get the number of times this color as been used
            NSNumber* colorCount = [colorCountMap objectForKey:colorKey];
            if(colorCount == nil) {
                colorCount = [NSNumber numberWithInt:0];
            }
            colorCount = [NSNumber numberWithInt:([colorCount intValue]+1)];
            [colorCountMap setObject:colorCount forKey:colorKey];
            
            if([colorCount intValue] == 500) {
                
                if(red == 0 && green == 0 && blue == 255) {
                    //ocean
                }else {
                    //land!
                    
                    NSLog(@"R=%d, G=%d, B=%d, pixel=%lu at location %d,%d", red, green, blue, pixel, x, y);
                    
                    
                    
                    NSString* territoryName = @"!UNKNOWN!";
                    for(id key in territoryInfoMap) {
                        NSDictionary* territoryInfo = [territoryInfoMap objectForKey:key];
                        int aRed = [(NSString*)([territoryInfo objectForKey:@"Red"]) intValue];
                        int aBlue = [(NSString*)([territoryInfo objectForKey:@"Blue"]) intValue];
                        int aGreen = [(NSString*)([territoryInfo objectForKey:@"Green"]) intValue];
                        
                        if(aRed == red && aBlue == blue && aGreen == green) {
                            territoryName = ((NSString*)key);
                            break;
                        }
                        
                        //NSLog(@"props: %d, %d, %d", aRed, aBlue, aGreen);
                    }
                    
                    Territory* territory = [[Territory alloc] initWithColor:pixel name:territoryName onMap:self];
                    [territoryWithColor setObject:territory forKey:colorKey];
                    if(DEBUG_MODE) {
                        NSLog(@"Added territory %@ for color key %@", territory.name, colorKey);
                    }
                }
            }else {
                
            }
            
            //map to grid coords
            gridX = x/GRID_SIZE;
            gridY = y/GRID_SIZE;
            if(gridY >= gridSize.height) gridY = gridSize.height-1;
            if(gridX >= gridSize.width) gridX = gridSize.width-1;
            gridI = (gridY * gridSize.width) + gridX;
            
            colorAtLocation[gridI] = pixel;   
        }
	}
    
    NSLog(@"Determining territory pixels...");
    
    for(id colorKey in territoryWithColor) {
        Territory* territory = [territoryWithColor objectForKey:colorKey];
        UInt32 territoryColor = [colorKey unsignedIntValue];
        
        NSMutableArray* locations = [[NSMutableArray alloc] init];

        for(int x = 0; x < size.width; x++) {
            for(int y = 0; y < size.height; y++) {
                
                [imageInspector colorAt:(CGPoint){x, size.height-y} 
                                    red:&red 
                                  green:&green 
                                   blue:&blue 
                                  alpha:&alpha 
                                  pixel:&pixel];  
                
                if(territoryColor == pixel) {
                    //this pixel belongs to this territory
                    [locations addObject:[NSNumber numberWithInt:((size.height-y)*size.width + x)]];
                }
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
	NSLog(@"Territory=%@", territory.name);

	return territory;
}






-(void) cleanup {
    if(colorAtLocation != nil) {
        free(colorAtLocation);
    }
    if(imageInspector != nil) {
        [imageInspector cleanup];
    }
}

- (void) dealloc {
    [self cleanup];
    NSLog(@"Map deallocated");
}

@end
