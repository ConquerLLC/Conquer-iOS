//
//  Map.h
//  Conquer
//
//  Created by Steve Johnson on 4/25/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define GRID_SIZE 1

@class Territory;
@class CGImageInspection;

@interface Map : NSObject {
    
	NSString* name;
	CGSize size;
	CGSize gridSize;

    CGImageInspection* imageInspector;
	UInt32* colorAtLocation;
    NSMutableDictionary* locationsWithColor;
	NSMutableDictionary* territoryWithColor;
    NSDictionary* properties;
	    
	CCSprite* displayNode;
}

-(id)initWithMapName:(NSString*)theMapName;
-(CCNode*)displayNode;
-(Territory*)territoryAtLocation:(CGPoint)location;
-(Territory*)territoryAtTouch:(UITouch*)touch;

-(void) cleanup;


@property (nonatomic) CGSize size;
@property (nonatomic) CGSize gridSize;
@property (strong, nonatomic) NSDictionary* properties;

@end
