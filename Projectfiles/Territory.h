//
//  Territory.h
//  Conquer
//
//  Created by Steve Johnson on 4/25/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Map;
@class Continent;
@class Player;

@interface Territory : NSObject {
    
    Map* map;
    Continent* continent;
    NSString* name;
	UInt32 color;
    
    NSArray* locations;
	NSArray* borderLocations;
    CGPoint center;
	
    NSArray* neighboringTerritories;
    
    Player* owner;
    int armies;
}

-(id)initWithColor:(UInt32)theColor name:(NSString*)theName onContinent:(Continent*)theContinent onMap:(Map*)theMap;
-(void)setLocations:(NSArray*)theLocations;

-(NSArray*)locations;
-(NSArray*)borderLocations;

-(void)setNeighboringTerritories:(NSArray*)theNeighboringTerritories;


-(void)highlightWithColor:(UInt32)highlightColor;
-(void)selectWithColor:(UInt32)selectColor;
    
    
@property (strong, nonatomic) NSString* name;
@property (nonatomic) CGPoint center;

@property (strong, nonatomic) Player* owner;
@property (nonatomic) int armies;

@end
