//
//  Territory.h
//  Conquer
//
//  Created by Steve Johnson on 4/25/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Map;

@interface Territory : NSObject {
    
    Map* map;
    NSArray* locations;
	CGPoint center;
	UInt32 color;
	
}

-(id)initWithColor:(UInt32)theColor onMap:(Map*)theMap;
-(void)setLocations:(NSArray*)theLocations;

-(NSArray*)locations;

-(void)highlight;
    
    
@end
