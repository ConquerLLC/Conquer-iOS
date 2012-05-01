//
//  EasyComputerPlayer.m
//  Conquer
//
//  Created by Stephen Johnson on 4/30/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import "EasyComputerPlayer.h"
#import "Territory.h"
#import "Map.h"
#include <unistd.h>

@implementation EasyComputerPlayer

short attackAttemptCount = 0;

-(id)initWithName:(NSString*)theName andColor:(UInt32)theColor onMap:(Map*)theMap {
	
	if ((self = [super initWithName:theName andColor:theColor onMap:theMap])) {
        NSLog(@"Difficulty is EASY");
    }
    
    return self;
}

-(void)place {
    NSLog(@"%@ is placing armies", name);
    
    if(armiesToPlace > 0) {       
        //pick a random territory
        NSArray* ownedTerritories = [map territoriesForPlayer:self];
        originTerritory = [ownedTerritories objectAtIndex:(int)(arc4random()%[ownedTerritories count])];
        
        int armies = ceil(armiesToPlace/5.0f);
        originTerritory.armies+= armies;
        armiesToPlace-= armies;
        NSLog(@"%@ placed %d units on territory %@. %@ has %d units to place. %@ has %d units", name, armies, originTerritory.name, name, armiesToPlace, originTerritory.name, originTerritory.armies);
        
        stateDescription = [NSString stringWithFormat:@"%d armies to place", armiesToPlace];
        
        usleep(500 * 1000);
    }else {
        [self endState];
    }
    
}

-(void)attack {
    NSLog(@"%@ is attacking", name);
    stateDescription = [NSString stringWithFormat:@"Attacking"];
    
    //pick a random territory
    NSArray* ownedTerritories = [map territoriesForPlayer:self];
    
    if(attackAttemptCount++ < 10) {
        short originSelectAttemptCount = 0;
        while((originTerritory == nil || originTerritory.armies < 2) && originSelectAttemptCount++ < 7) {
            originTerritory = [ownedTerritories objectAtIndex:(int)(arc4random()%[ownedTerritories count])];
            uint ownedNeighborCount = [[originTerritory neighboringTerritoriesForPlayer:self] count];
            if(ownedNeighborCount == [[originTerritory neighboringTerritories] count]) {
                originTerritory = nil;
            }
        }
        
        short destinationSelectAttemptCount = 0;
        while((destinationTerritory == nil || destinationTerritory.owner == self) && destinationSelectAttemptCount++ < 7) {
            destinationTerritory = [originTerritory.neighboringTerritories objectAtIndex:(int)(arc4random()%[originTerritory.neighboringTerritories count])];
        }
    
        if(destinationTerritory.owner == self) {
            return;
        }
        
        //try and attack
        NSLog(@"%@ is attacking from %@ to %@", name, originTerritory.name, destinationTerritory.name);
        stateDescription = [NSString stringWithFormat:@"Attacking %@", destinationTerritory.name];
        
        [originTerritory attack:destinationTerritory];
        
        originTerritory = nil;
        destinationTerritory = nil;
        
        usleep(500 * 1000);
        
    }else {
        [self endState];
    }
}

-(void)fortify {
    NSLog(@"%@ is fortifying", name);
    
    
    [self endState];
}

-(void)endState {
    attackAttemptCount = 0;
    [super endState];
}

@end
