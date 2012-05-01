//
//  Player.m
//  Conquer
//
//  Created by Stephen Johnson on 4/29/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import "Player.h"
#import "Territory.h"
#import "Map.h"

@implementation Player

@synthesize originTerritory;
@synthesize destinationTerritory;
@synthesize name;
@synthesize color;

@synthesize state;
@synthesize lastState;
@synthesize stateDescription;

@synthesize armiesToPlace;

-(id)initWithName:(NSString*)theName andColor:(UInt32)theColor onMap:(Map*)theMap {
	
	if ((self = [super init])) {
        name = theName;
        color = theColor;
        map = theMap;
        originTerritory = nil;
        destinationTerritory = nil;
        
        state = STATE_GAME_NOT_STARTED;
        lastState = STATE_GAME_NOT_STARTED;
        stateDescription = @"Game not started";
        
        armiesToPlace = 0;
    }
    
    return self;
}

-(void)place {
    NSLog(@"OVERRIDE place!!!");

}

-(void)attack {
    NSLog(@"OVERRIDE attack!!!");

}

-(void)fortify {
    NSLog(@"OVERRIDE fortify!!!");
}

-(void)endState {
    lastState = state;
    state = (state+1)%NUM_STATES;
    stateDescription = @"";
    NSLog(@"%@ finished state", name);
}

-(void)endTurn {
    lastState = state;
    state = STATE_IDLE;
    stateDescription = @"";
    NSLog(@"%@ finished turn", name);
}

-(void)touchedTerritory:(Territory*)territory {
    
    if(territory == nil) {
        //water was touched
        originTerritory = nil;
        destinationTerritory = nil;
        return;
    }
    
    
    if(territory.owner == self) {
        //territory IS owned
        
        //selecting oneself deselects when not PLACING
        if(originTerritory == territory && state != STATE_PLACING) {
            originTerritory = nil;
            destinationTerritory = nil;
            return;
        }

        if(state == STATE_ATTACKING) {
            //if we're attacking then this must be the the origin
            if(territory.armies > 1) {
                //valid attack starting point!
                originTerritory = territory;
                destinationTerritory = nil;   
            }else {
                originTerritory = nil;
                destinationTerritory = nil;
            }
        }else if(state == STATE_PLACING) {
            //if we're placing then only the origin matters
            originTerritory = territory;
            destinationTerritory = nil;
        }else if(state == STATE_FORTIFYING) {
            //if we're fortifying then both are owned by the player
            if(originTerritory != nil) {
                if(destinationTerritory == nil && [originTerritory isNeighborTo:territory]) {
                    destinationTerritory = territory;
                }else {
                    originTerritory = territory;
                }
            }else {
                originTerritory = territory;
            }
        }
    }else {
        //territory is NOT owned
        
        if(state == STATE_ATTACKING) {
            //if we're attacking then the origin must be set
            if(originTerritory != nil && [originTerritory isNeighborTo:territory]) {
                destinationTerritory = territory;
            }else {
                //invalid touch
                destinationTerritory = nil;
           }
        }else if(state == STATE_PLACING) {
            //if we're placing then this is an invalid touch
            originTerritory = nil;
            destinationTerritory = nil;

        }else if(state == STATE_FORTIFYING) {
            //if we're fortifying then this is an invalid touch
            destinationTerritory = nil;
       
        }
    }
}

-(void)dealloc {
    
    NSLog(@"Player %@ deallocated", name);
}

@end
