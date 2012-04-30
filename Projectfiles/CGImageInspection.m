// CGImageInspection.m

#import "CGImageInspection.h"

@interface CGImageInspection ()

- (id) initWithCGImage: (CGImageRef) imageRef ;

@property (assign, nonatomic) CGContextRef  context ;
@property (assign, nonatomic) void *        pixels ;
@property (assign, nonatomic) NSUInteger    bytesPerRow ;
@property (assign, nonatomic) NSUInteger    bytesPerPixel ;

@end

@implementation CGImageInspection

@synthesize context ;
@synthesize pixels ;
@synthesize bytesPerRow ;
@synthesize bytesPerPixel ;


+ (CGImageInspection *) imageInspectionWithCGImage: (CGImageRef) imageRef {
    return [[CGImageInspection alloc] initWithCGImage:imageRef] ;
}

- (id) initWithCGImage: (CGImageRef) imageRef {
    
    if (self = [super init]) {
        size_t  pixelsWide = CGImageGetWidth(imageRef) ;
        size_t  pixelsHigh = CGImageGetHeight(imageRef) ;
                
        self.bytesPerPixel = 4 ;
        self.bytesPerRow = (pixelsWide * self.bytesPerPixel) ;
        int     bitmapByteCount   = (self.bytesPerRow * pixelsHigh) ;
        
        NSLog(@"Loading image with dimensions: %zu x %zu. Byte count = %d", pixelsWide, pixelsHigh, bitmapByteCount);
        
        CGColorSpaceRef colorSpace= CGColorSpaceCreateDeviceRGB() ;
        
        if (colorSpace == 0) {
            return nil ;
        }
        
        self.pixels = calloc(bitmapByteCount, 1) ;
        if (self.pixels == 0) {
            CGColorSpaceRelease(colorSpace) ;
            return nil ;
        }
        
        self.context = CGBitmapContextCreate(
                                               self.pixels
                                               ,   pixelsWide
                                               ,   pixelsHigh
                                               ,   8      // bits per component
                                               ,   self.bytesPerRow
                                               ,   colorSpace
                                               ,   kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big) ;
        
        if (self.context == NULL) {
            free(self.pixels) ;
            self.pixels = 0 ;
            CGColorSpaceRelease(colorSpace);
            return nil ;
        }
        CGContextDrawImage(context, (CGRect) {{0, 0}, {pixelsWide, pixelsHigh}}, imageRef) ;
        CGColorSpaceRelease(colorSpace) ;
        
        
        NSLog(@"Image context created");
    }
    
    return self ;
    
}

- (void) colorAt: (CGPoint) location
             red: (UInt8 *) red 
           green: (UInt8 *) green
            blue: (UInt8 *) blue
           alpha: (UInt8 *) alpha
           pixel: (UInt32 *) pixel{
    
    int yy = (int) location.y ;
    int xx = (int) location.x ;
    
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel ;
    UInt8* raw = (UInt8*) self.pixels ;
    raw += byteIndex ;
        
    *red    = ((*raw++));
    *green  = ((*raw++));
    *blue   = ((*raw++));
    *alpha  = ((*raw++));
    
    *pixel = ((*red)) + ((*green)<<8) + ((*blue)<<16) + ((*alpha)<<24);
}

- (UInt32) colorAt: (CGPoint) location {
    int yy = (int) location.y ;
    int xx = (int) location.x ;
    
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel ;
    
    return *((UInt32*)(self.pixels+byteIndex));
}


-(void) cleanup {
    if (self.context) {
        CGContextRelease(self.context) ;
        self.context = 0 ;
    }
    
    if (self.pixels) {
        free(self.pixels) ;
        self.pixels = 0 ;
    }
}

- (void) dealloc {
    [self cleanup];
    NSLog(@"CGImageInspection deallocated") ;
}

@end
