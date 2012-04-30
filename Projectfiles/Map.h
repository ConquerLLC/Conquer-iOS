//
//  Map.h
//  Conquer
//
//  Created by Steve Johnson on 4/25/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Territory;
@class CGImageInspection;

@interface Map : NSObject {
    
	NSString* name;
	CGSize size;

    CGImageInspection* imageInspector;
    
    NSMutableDictionary* continents;
    
    NSMutableDictionary* locationsWithColor;
	NSMutableDictionary* territoryWithColor;
    NSDictionary* properties;
    
	CCSprite* displayNode;
}

-(id)initWithMapName:(NSString*)theMapName;
-(CCNode*)displayNode;
-(Territory*)territoryAtLocation:(CGPoint)location;
-(Territory*)territoryAtTouch:(UITouch*)touch;
-(NSArray*)territories;

-(void) cleanup;


@property (nonatomic) CGSize size;
@property (strong, nonatomic) NSDictionary* properties;
@property (strong, nonatomic) NSMutableDictionary* continents;

@end
