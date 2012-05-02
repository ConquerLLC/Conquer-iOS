//
//  GAWrapper.h
//  Conquer
//
//  Created by Stephen Johnson on 5/1/12.
//  Copyright (c) 2012 Conquer, LLC. All rights reserved.
//

#ifndef Conquer_GAWrapper_h
#define Conquer_GAWrapper_h

#import "GANTracker.h"



static NSInteger GA_CUSTOM_VARIABLE_INDEX = 1;

#define GALogEvent(_category, _action, _label, _value) (^{\
		NSError *error;\
		if (![[GANTracker sharedTracker] \
					 trackEvent:_category\
					 action:_action\
					 label:_label\
					 value:_value\
					 withError:&error]) {\
		NSLog(@"GA: error in trackEvent: %@", error);\
	}\
})();


#define GASetVar(_name, _value) (^{\
		NSError *error;\
		if (![[GANTracker sharedTracker] \
					setCustomVariableAtIndex: GA_CUSTOM_VARIABLE_INDEX++\
					name:_name\
					value:_value\
					withError:&error]) {\
		NSLog(@"GA: error in setCustomVariableAtIndex: %@", error);\
	}\
})();


#define GALogPageView(_name) (^{\
	NSError *error;\
	if (![[GANTracker sharedTracker] \
					trackPageview: _name\
					withError:&error]) {\
	NSLog(@"GA: error in trackPageView: %@", error);\
	}\
})();


#endif
