/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "Constants.h"
#import "Crittercism.h"
#import "AppDelegate.h"

@implementation AppDelegate

-(void) initializationComplete
{
#ifdef KK_ARC_ENABLED
	CCLOG(@"ARC is enabled");
#else
	CCLOG(@"ARC is either not available or not enabled");
#endif
	
	
	
	
	[self initializeGoogleAnalytics];

	[self initializeCrittercism];

}

-(void)initializeCrittercism {
	NSLog(@"Initializing Crittercism");
	//initialize Crittercism for crash reporting (https://www.crittercism.com/developers/docs)
    if(!DEBUG_MODE) {
		[Crittercism initWithAppID: @"4fa06fabb09315487d0000c9"
							andKey:@"tcsqy9w16rpdl3achkorylf5hpxx"
						 andSecret:@"snouryb9xqm4lkn2mh0b8ua6lwoegqex"];
		
    }	
}

-(void)initializeGoogleAnalytics {
	NSLog(@"Initializing Google Analytics");

	const NSInteger kGANDispatchPeriodSec = 10;
	[[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-31019270-2"
										   dispatchPeriod:kGANDispatchPeriodSec
												 delegate:nil];
	
	
	
	if(DEBUG_MODE) {
		GASetVar(@"DebugMode", @"YES");
	}
	
}

-(id) alternateRootViewController
{
	return nil;
}

-(id) alternateView
{
	return nil;
}

@end
