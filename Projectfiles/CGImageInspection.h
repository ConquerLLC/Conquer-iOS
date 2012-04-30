// CGImageInspection.h
#import <Foundation/Foundation.h>

@interface CGImageInspection : NSObject

+ (CGImageInspection *) imageInspectionWithCGImage: (CGImageRef) imageRef ;

- (void) colorAt: (CGPoint) location
             red: (UInt8 *) red 
           green: (UInt8 *) green
            blue: (UInt8 *) blue
           alpha: (UInt8 *) alpha 
           pixel: (UInt32 *) pixel;

- (UInt32) colorAt: (CGPoint) location;

-(void) cleanup;

@end