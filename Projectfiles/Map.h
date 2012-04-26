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

@class Country;

@interface Map : NSObject {
    
	NSString* name;
	CGSize size;
	CGSize gridSize;

	UInt32* hitMap;
	NSMutableDictionary* countries;
	
	CCSprite* displayNode;
}

-(id)initWithMapName:(NSString*)theMapName;
-(CCNode*)displayNode;
-(Country*)countryAtLocation:(CGPoint)location;
-(Country*)countryAtTouch:(UITouch*)touch;

@end
