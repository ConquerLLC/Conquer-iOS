//
//  Player.h
//  Conquer
//
//  Created by Stephen Johnson on 4/29/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerProtocol.h"


#define STATE_IDLE 0
#define STATE_PLACING 1
#define STATE_HAS_PLACED 2
#define STATE_ATTACKING 3
#define STATE_HAS_ATTACKED 4
#define STATE_FORTIFYING 5
#define STATE_HAS_FORTIFIED 6
#define NUM_STATES 7

#define STATE_GAME_NOT_STARTED 100
#define STATE_GAME_LOST 200
#define STATE_GAME_WON 300

@class Territory;
@class Map;

@interface Player : NSObject <PlayerProtocol> {

    NSString* name;
    UInt32 color;
    Map* map;
    
    Territory* originTerritory;
    Territory* destinationTerritory;
        
    ushort state;
    ushort lastState;
    
    NSString* stateDescription;
    
    int armiesToPlace;
}

-(id)initWithName:(NSString*)theName andColor:(UInt32)theColor onMap:(Map*)theMap;

-(void)touchedTerritory:(Territory*)territory;

@property (strong, nonatomic) NSString* name;
@property (nonatomic) UInt32 color;
@property (strong, nonatomic) Territory* originTerritory;
@property (strong, nonatomic) Territory* destinationTerritory;
@property (strong, nonatomic) NSString* stateDescription;

@property (nonatomic) ushort state;
@property (nonatomic) ushort lastState;
@property (nonatomic) int armiesToPlace;


@end
