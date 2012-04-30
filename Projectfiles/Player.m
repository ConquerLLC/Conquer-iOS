//
//  Player.m
//  Conquer
//
//  Created by Stephen Johnson on 4/29/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import "Player.h"
#import "Territory.h"

@implementation Player

@synthesize originTerritory;
@synthesize destinationTerritory;
@synthesize name;
@synthesize color;

@synthesize state;
@synthesize lastState;

-(id)initWithName:(NSString*)theName andColor:(UInt32)theColor {
	
	if ((self = [super init])) {
        name = theName;
        color = theColor;
        originTerritory = nil;
        destinationTerritory = nil;
        
        state = STATE_GAME_NOT_STARTED;
        lastState = STATE_GAME_NOT_STARTED;
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


-(void)endTurn {
    lastState = state;
    state = (state+1)%NUM_STATES;
    NSLog(@"%@ finished turn", name);
}

-(void)touchedTerritory:(Territory*)territory {
    if(territory.owner == self) {
        //territory IS owned

        if(state == STATE_ATTACKING) {
            //if we're attacking then this must be the the origin
            originTerritory = territory;
            destinationTerritory = nil;
        }else if(state == STATE_PLACING) {
            //if we're placing then only the origin matters
            originTerritory = territory;
            destinationTerritory = nil;
        }else if(state == STATE_FORTIFYING) {
            //if we're fortifying then both are owned by the player
            if(originTerritory != nil) {
                if(destinationTerritory == nil) {
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
            if(originTerritory != nil) {
                destinationTerritory = territory;
            }else {
                originTerritory = nil;
                destinationTerritory = nil;
            }
        }else if(state == STATE_PLACING) {
            //if we're placing then this is an invalid touch
            originTerritory = nil;
            destinationTerritory = nil;
        }else if(state == STATE_FORTIFYING) {
            //if we're fortifying then this is an invalid touch
            originTerritory = nil;
            destinationTerritory = nil;            
        }
    }
}

-(NSString*)stateName {
    if(state == STATE_IDLE) {
        return @"Idle";
    }else if(state == STATE_PLACING) {
        return @"Placing";
    }else if(state == STATE_HAS_PLACED) {
        return @"Has Placed";
    }else if(state == STATE_ATTACKING) {
        return @"Attacking";
    }else if(state == STATE_HAS_ATTACKED) {
        return @"Has Attacked";
    }else if(state == STATE_FORTIFYING) {
        return @"Fortifying";
    }else if(state == STATE_HAS_FORTIFIED) {
        return @"Has Fortified";
    }else if(state == STATE_GAME_NOT_STARTED) {
        return @"Game Not Yet Started";
    }else if(state == STATE_GAME_WON) {
        return @"Game Won";
    }else if(state == STATE_GAME_LOST) {
        return @"Game Lost";
    }else {
        return @"Unknown";
    }
}

-(void)dealloc {
    
    NSLog(@"Player %@ deallocated", name);
}

@end
