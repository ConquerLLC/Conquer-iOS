//
//  PlayerProtocol.h
//  Conquer
//
//  Created by Stephen Johnson on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerProtocol <NSObject>

@required

- (void)setup;

- (void)place;
- (void)attack;
- (void)fortify;

- (void)endState;
- (void)endTurn;
@end
