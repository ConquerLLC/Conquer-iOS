//
//  Continent.h
//  Conquer
//
//  Created by Stephen Johnson on 4/26/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Map;
@class Territory;

@interface Continent : NSObject {
    
    Map* map;
    
    NSString* name;
    int armiesPerTurn;
    NSMutableArray* territories;
}

-(id)initWithName:(NSString*)theName armiesPerTurn:(int)theArmiesPerTurn onMap:(Map*)theMap;
-(NSArray*)territories;
-(void)addTerritory:(Territory*)territory;

@property (strong, nonatomic) NSString* name;


@end
