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
@synthesize color;
@synthesize neighboringTerritories;
@synthesize armies = _armies;

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
        
        labelArmies = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:24];
        [map.HUD addChild: labelArmies];
        
        [self setArmies:map.initialArmiesPerTerritory];
        
        NSLog(@"Created territory %@ on continent %@", name, continent.name);
	}
	return self;
}

-(void)setArmies:(int)theArmies {
    _armies = theArmies;
    labelArmies.string = [NSString stringWithFormat:@"%d", self.armies];
}

-(BOOL)isNeighborTo:(Territory*)territory {
    //NSLog(@"Checking if %@ neighbors %@", territory.name, name);
    for(Territory* neighbor in neighboringTerritories) {
        if(territory == neighbor) {
            return true;
        }
    }
    return false;
}

//return TRUE if the attack succeeded
-(BOOL)attack:(Territory*)territory {
    
    //can't attack oneself
    if(territory.owner == owner) {
        NSLog(@"Attempted to attack a territory that was already owned");
        return true;
    }
    
    //must have at least two armies to attack with
    if(self.armies < 2) {
        NSLog(@"Must have at least 2 armies to attack with a territory. (%@ has %d)", name, self.armies);
        return false;
    }
    
    //TODO: add in the risk-style attack logic
    //TODO: add in the ability to keep some units back
    
    short attackRoll = (short)(arc4random()%6 + 1);
    short defenseRoll = (short)(arc4random()%6 + 1);
    
    if(attackRoll > defenseRoll) {
        //attacker wins
        territory.armies--;
    }else {
        //defender wins
        self.armies--;
    }
    
    NSLog(@"Attacked %@ from %@. %@ rolled %d, %@ rolled %d", territory.name, name, territory.name, defenseRoll, name, attackRoll);
    
    if(territory.armies <= 0) {
        territory.owner = owner;
        territory.armies = self.armies-1;
        self.armies = 1;
        return true;
    }
    
    return false;
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
    labelArmies.position = center;
    
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

-(NSArray*)neighboringTerritoriesWithOwner:(Player*)player {
    NSMutableArray* territoriesArray = [[NSMutableArray alloc] init];
    for(Territory* territory in neighboringTerritories) {
        if(territory.owner == owner) {
            [territoriesArray addObject:territory];
        }
    }
    return territoriesArray;
}

-(NSArray*)neighboringTerritoriesWithoutOwner:(Player*)player {
    NSMutableArray* territoriesArray = [[NSMutableArray alloc] init];
    for(Territory* territory in neighboringTerritories) {
        if(territory.owner != owner) {
            [territoriesArray addObject:territory];
        }
    }
    return territoriesArray;
}

-(void)selectWithColor:(UInt32)selectColor {
    UInt8 red = (selectColor) & 0xFF;
    UInt8 green = (selectColor>>8) & 0xFF;
    UInt8 blue = (selectColor>>16) & 0xFF;
    UInt8 alpha = (selectColor>>24) & 0xFF;
    
    glLineWidth(3);
    
    glColor4ub(red, green, blue, alpha);
    ccDrawCircle(center, 25, CC_DEGREES_TO_RADIANS(360), 10, NO);
}

-(void)highlightWithColor:(UInt32)highlightColor {
    
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
