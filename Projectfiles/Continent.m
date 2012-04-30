//
//  Continent.m
//  Conquer
//
//  Created by Stephen Johnson on 4/26/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import "Continent.h"
#import "Territory.h"

@implementation Continent 

@synthesize name;

-(id)initWithName:(NSString*)theName armiesPerTurn:(int)theArmiesPerTurn onMap:(Map*)theMap {
    if((self = [super init])) {
        name = theName;
        armiesPerTurn = theArmiesPerTurn;
        map = theMap;
        territories = [[NSMutableArray alloc] init];
        NSLog(@"Created continent %@ with %d armies per turn", name, armiesPerTurn);
	}
	return self;
}

-(NSArray*)territories {
    return territories;
}

-(void)addTerritory:(Territory*)territory {
    [territories addObject:territory];
    NSLog(@"Added territory %@ to continent %@", territory.name, name);
}



-(void)dealloc {
    
    NSLog(@"Continent %@ deallocated", name);
}




@end
