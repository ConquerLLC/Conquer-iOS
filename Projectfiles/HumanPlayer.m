//
//  HumanPlayer.m
//  Conquer
//
//  Created by Stephen Johnson on 4/29/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import "HumanPlayer.h"

@implementation HumanPlayer

-(id)initWithName:(NSString*)theName andColor:(UInt32)theColor {
	
	if ((self = [super initWithName:theName andColor:theColor])) {
        NSLog(@"New human player created with name=%@ and color=%lu", name, color);
    }
        
    return self;
}

-(void)place {
    NSLog(@"%@ is placing armies", name);

    
    //[self endTurn];
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
