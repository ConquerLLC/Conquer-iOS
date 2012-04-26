//
//  Country.h
//  Conquer
//
//  Created by Steve Johnson on 4/25/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Country : NSObject {
    
	CGPoint center;
	UInt32 color;
	
}

-(id)initWithCenter:(CGPoint)theCenter andColor:(UInt32)theColor;


@end
