//
//  UIColor_ColorFromUInt32.m
//  Conquer
//
//  Created by Stephen Johnson on 4/30/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#import "UIColor_ColorFromUInt32.h"

@implementation UIColor (colorFromUInt32)
+(UIColor*)colorWithUInt32:(UInt32)color {    
    int red = (color) & 0xFF;
    int green = (color>>8) & 0xFF;
    int blue = (color>>16) & 0xFF;
    int alpha = (color>>24) & 0xFF;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
@end
