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
@synthesize properties;
@synthesize continents;

@synthesize HUD;

-(id)initWithMapName:(NSString*)theMapName andHudLayer:(CCNode*)theHUD {
	
	if ((self = [super init])) {
		
		name = theMapName;
        HUD = theHUD;
        size = [[CCDirector sharedDirector] winSize];

        continents = [[NSMutableDictionary alloc] init];
		territoryWithColor = [[NSMutableDictionary alloc] init];
        locationsWithColor = [[NSMutableDictionary alloc] init];
        
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

-(NSArray*)territories {
    NSMutableArray* territoriesArray = [[NSMutableArray alloc] init];
    for(id key in territoryWithColor) {
        [territoriesArray addObject:[territoryWithColor objectForKey:key]];
    }
    return territoriesArray;
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
    NSDictionary* continentInfoMap = [properties objectForKey:@"Continents"];
    NSMutableDictionary* continentToTerritoryNamesMap = [[NSMutableDictionary alloc] init];
    
    for(id key in continentInfoMap) {
        NSDictionary* continentInfo = [continentInfoMap objectForKey:key];
        NSString* continentName = ((NSString*)key);
        int armiesPerTurn = [(NSString*)([continentInfo objectForKey:@"ArmiesPerTurn"]) intValue];
        NSArray* territories = (NSArray*)([continentInfo objectForKey:@"Territories"]);
        
        Continent* continent = [[Continent alloc] initWithName:continentName armiesPerTurn:armiesPerTurn onMap:self];
        [continents setObject:continent forKey:continentName];
        [continentToTerritoryNamesMap setObject:territories forKey:continent.name];
    }
    
    NSLog(@"Creating hitmap");
	
	UIImage *hitmapImage = [UIImage imageNamed:[NSString stringWithFormat:@"Maps/%@/HitMap.png", name]];
    
    imageInspector = [CGImageInspection imageInspectionWithCGImage:hitmapImage.CGImage];
	
    UInt32 pixel;
    UInt8 red;
    UInt8 green;
    UInt8 blue;
    UInt8 alpha;
        
	NSLog(@"Mapping pixels to colors and territories");
	for(int x = 0; x < size.width; x+=5) {
        for(int y = 0; y < size.height; y+=5) {
            
            //get the aggregate pixel value (fast)
            pixel = [imageInspector colorAt:(CGPoint){x, size.height-1-y}];  
                       
            NSNumber* colorKey = [NSNumber numberWithUnsignedInt:pixel];
            Territory* territory = [territoryWithColor objectForKey:colorKey];

            if(territory == nil) {
                
                //get the RGB values
                [imageInspector colorAt:(CGPoint){x, size.height-1-y} 
                                    red:&red 
                                  green:&green 
                                   blue:&blue 
                                  alpha:&alpha 
                                  pixel:&pixel];
                
                if(red == 0 && green == 0 && blue == 255) {
                    //ocean
                }else {
                    //land!
                    
                    if(DEBUG_MODE) {
                        NSLog(@"R=%d, G=%d, B=%d, pixel=%lu at location %d,%d", red, green, blue, pixel, x, y);
                    }
                    
                    
                    NSString* territoryName = @"!UNKNOWN!";
                    NSArray* neighboringTerritories = nil;
                    for(id key in territoryInfoMap) {
                        NSDictionary* territoryInfo = [territoryInfoMap objectForKey:key];
                        int aRed = [(NSString*)([territoryInfo objectForKey:@"Red"]) intValue];
                        int aBlue = [(NSString*)([territoryInfo objectForKey:@"Blue"]) intValue];
                        int aGreen = [(NSString*)([territoryInfo objectForKey:@"Green"]) intValue];
                        
                        if(aRed == red && aBlue == blue && aGreen == green) {
                            territoryName = ((NSString*)key);
                            neighboringTerritories = (NSArray*)([territoryInfo objectForKey:@"Neighbors"]);
                            break;
                        }
                        
                        //NSLog(@"props: %d, %d, %d", aRed, aBlue, aGreen);
                    }
                                        
                    Continent* continent = nil;
                    for(id key in continents) {
                        Continent* aContinent = [continents objectForKey:key];
                        for(NSString* aTerritoryName in [continentToTerritoryNamesMap objectForKey:aContinent.name]) {
                            if([aTerritoryName isEqualToString:territoryName]) {
                                continent = aContinent;
                                break;
                            }
                        }
                    }
                    
                    territory = [[Territory alloc] initWithColor:pixel name:territoryName onContinent:continent onMap:self];
                    if(neighboringTerritories != nil) {
                        [territory setNeighboringTerritories:neighboringTerritories];
                    }
                    
                    [continent addTerritory:territory];
                    
                    [territoryWithColor setObject:territory forKey:colorKey];
                    
                    if(DEBUG_MODE) {
                        NSLog(@"Added territory %@ for color key %@", territory.name, colorKey);
                    }
                }
            }else {
                
            }
        }
	}
    
    NSLog(@"Determining territory pixels...");
    
    for(id colorKey in territoryWithColor) {
        Territory* territory = [territoryWithColor objectForKey:colorKey];
        UInt32 territoryColor = [colorKey unsignedIntValue];
        
        NSMutableArray* locations = [[NSMutableArray alloc] init];

        for(int x = 0; x < size.width; x+=3) {
            for(int y = 0; y < size.height; y+=3) {
                
                pixel = [imageInspector colorAt:(CGPoint){x, size.height-1-y}];  
                
                if(territoryColor == pixel) {
                    //this pixel belongs to this territory
                    [locations addObject:[NSNumber numberWithInt:((size.height-1-y)*size.width + x)]];
                }
            }
        }
    
        [territory setLocations:locations];
    }
	
	NSLog(@"Hitmap created");
    
    
}	

-(UInt32)colorAtLocation:(CGPoint)location {
	return [imageInspector colorAt:(CGPoint){location.x, size.height-1-location.y}];
}

-(CGPoint)locationFromTouch:(UITouch*)touch {
	CGPoint touchLocation = [touch locationInView:[touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

-(Territory*)territoryAtTouch:(UITouch*)touch {
	CGPoint location = [self locationFromTouch:touch];
	return [self territoryAtLocation:location];
}

-(Territory*)territoryAtLocation:(CGPoint)location {
	
    UInt32 pixel;
    UInt8 red;
    UInt8 green;
    UInt8 blue;
    UInt8 alpha;
    
	[imageInspector colorAt:(CGPoint){location.x, size.height-1-location.y} 
                        red:&red 
                      green:&green 
                       blue:&blue 
                      alpha:&alpha 
                      pixel:&pixel];
    
    if(DEBUG_MODE) {
        NSLog(@"R=%d, G=%d, B=%d, A=%d at location %d,%d", red, green, blue, alpha, (int)location.x, (int)location.y);
	}
    
	NSNumber* colorKey = [NSNumber numberWithUnsignedInt:pixel];
	Territory* territory = [territoryWithColor objectForKey:colorKey];
    
    if(DEBUG_MODE) {
        NSLog(@"Territory=%@", territory.name);
    }
    
	return territory;
}






-(void) cleanup {
    if(imageInspector != nil) {
        [imageInspector cleanup];
    }
}

- (void) dealloc {
    [self cleanup];
    NSLog(@"Map deallocated");
}

@end
