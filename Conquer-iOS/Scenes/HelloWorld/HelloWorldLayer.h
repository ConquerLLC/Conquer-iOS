//
//  HelloWorldLayer.h
//  Conquer-iOS
//
//  Created by Steve Johnson on 4/19/12.
//  Copyright ConquerCorp 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// Importing Chipmunk headers
#import "chipmunk.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	cpSpace *space;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
