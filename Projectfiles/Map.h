//
//  Map.h
//  Conquer
//
//  Created by Steve Johnson on 4/25/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Territory;
@class CGImageInspection;
@class Player;

@interface Map : NSObject {
    
	NSString* name;
	CGSize size;

    CGImageInspection* imageInspector;
    
    NSMutableDictionary* continents;
    
    NSMutableDictionary* locationsWithColor;
	NSMutableDictionary* territoryWithColor;
    NSDictionary* properties;
    int initialArmiesPerTerritory;
    int armiesPerTurn;
    int territoriesForAdditionalArmyPerTurn;
    
	CCSprite* displayNode;
    CCNode* HUD;
}

-(id)initWithMapName:(NSString*)theMapName andHudLayer:(CCNode*)theHUD;
-(CCNode*)displayNode;
-(Territory*)territoryAtLocation:(CGPoint)location;
-(Territory*)territoryAtTouch:(UITouch*)touch;
-(NSArray*)territories;
-(NSArray*)territoriesForPlayer:(Player*)player;

-(void) cleanup;


@property (nonatomic) CGSize size;
@property (strong, nonatomic) NSMutableDictionary* continents;
@property (strong, nonatomic) CCNode* HUD;

@property (strong, nonatomic) NSDictionary* properties;
@property (nonatomic) int initialArmiesPerTerritory;
@property (nonatomic) int armiesPerTurn;
@property (nonatomic) int territoriesForAdditionalArmyPerTurn;


@end
