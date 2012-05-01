//
//  ComputerPlayer.m
//  Conquer
//
//  Created by Stephen Johnson on 4/30/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import "ComputerPlayer.h"
#import "Territory.h"

@implementation ComputerPlayer

-(id)initWithName:(NSString*)theName andColor:(UInt32)theColor onMap:(Map*)theMap {
	
	if ((self = [super initWithName:theName andColor:theColor onMap:theMap])) {
        NSLog(@"New computer player created with name=%@ and color=%lu", name, color);
    }
    
    return self;
}


- (void)setup {
    
}

@end
