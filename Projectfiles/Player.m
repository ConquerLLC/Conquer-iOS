//
//  Player.m
//  Conquer
//
//  Created by Stephen Johnson on 4/29/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import "Player.h"

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

@end
