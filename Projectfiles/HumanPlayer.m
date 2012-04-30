//
//  HumanPlayer.m
//  Conquer
//
//  Created by Stephen Johnson on 4/29/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import "HumanPlayer.h"
#import "Territory.h"

@implementation HumanPlayer

-(id)initWithName:(NSString*)theName andColor:(UInt32)theColor {
	
	if ((self = [super initWithName:theName andColor:theColor])) {
        NSLog(@"New human player created with name=%@ and color=%lu", name, color);
    }
        
    return self;
}

-(void)touchedTerritory:(Territory*)territory {
    [super touchedTerritory:territory];
    
    if(state == STATE_PLACING) {
        if(originTerritory == nil) {
            return;
        }
        if(armiesToPlace > 0) {
            originTerritory.armies++;
            armiesToPlace--;
            NSLog(@"%@ placed unit on territory %@. %@ has %d units. %@ has %d units", name, originTerritory.name, name, armiesToPlace, originTerritory.name, originTerritory.armies);
            if(armiesToPlace > 0) {
                stateDescription = [NSString stringWithFormat:@"%d armies to place", armiesToPlace];
            }else {
                [self endTurn];
            }
        }else {
            [self endTurn];
        }
    }
}

-(void)place {
    NSLog(@"%@ is placing armies", name);
    
    if(armiesToPlace > 0) {
        stateDescription = [NSString stringWithFormat:@"%d armies to place", armiesToPlace];
    }else {
        [self endTurn];
    }
    
}

-(void)attack {
    NSLog(@"%@ is attacking", name);


    [self endTurn];
}

-(void)fortify {
    NSLog(@"%@ is fortifying", name);

    
    [self endTurn];
}


@end
