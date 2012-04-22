//
//  AppDelegate.h
//  Conquer-iOS
//
//  Created by Steve Johnson on 4/19/12.
//  Copyright ConquerCorp 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
