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
    NSString* name;
	UInt32 color;

    
    NSArray* locations;
	NSArray* borderLocations;
    CGPoint center;
	
}

-(id)initWithColor:(UInt32)theColor name:(NSString*)theName onMap:(Map*)theMap;
-(void)setLocations:(NSArray*)theLocations;

-(NSArray*)locations;
-(NSArray*)borderLocations;

-(void)highlight;
    
    
@property (strong, nonatomic) NSString* name;
@property (nonatomic) CGPoint center;

@end
