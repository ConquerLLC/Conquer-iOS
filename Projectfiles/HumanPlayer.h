//
//  HumanPlayer.h
//  Conquer
//
//  Created by Stephen Johnson on 4/29/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import "Player.h"

@interface HumanPlayer : Player <PlayerProtocol>



-(id)initWithName:(NSString*)theName andColor:(UInt32)theColor onMap:(Map*)theMap;

@end

