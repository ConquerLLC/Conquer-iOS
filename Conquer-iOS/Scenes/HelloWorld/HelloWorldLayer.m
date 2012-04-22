//
//  HelloWorldLayer.m
//  Conquer-iOS
//
//  Created by Steve Johnson on 4/19/12.
//  Copyright ConquerCorp 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "CCTouchDispatcher.h"
#import "GameModeSelectionScene.h"

CCSprite *seeker1;
CCSprite *cocosGuy;

enum {
	kTagBatchNode = 1,
};

static void
eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	CCSprite *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		
		// TIP: cocos2d and chipmunk uses the same struct to store it's position
		// chipmunk uses: cpVect, and cocos2d uses CGPoint but in reality the are the same
		// since v0.7.1 you can mix them if you want.		
		[sprite setPosition: body->p];
		
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// create and initialize our seeker sprite, and add it to this layer
        seeker1 = [CCSprite spriteWithFile: @"seeker.png"];
        seeker1.position = ccp( 50, 100 );
        [self addChild:seeker1];
        
        // do the same for our cocos2d guy, reusing the app icon as its image
        cocosGuy = [CCSprite spriteWithFile: @"Icon.png"];
        cocosGuy.position = ccp( 200, 300 );
        [self addChild:cocosGuy];
        
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
        
        self.isTouchEnabled = YES;
	
    
    
    
    
    
    
        // register to receive targeted touch events
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                         priority:0
                                                  swallowsTouches:YES];
    
        // Create some menu items
        CCMenuItemImage * menuItem1 = [CCMenuItemImage itemFromNormalImage: [[NSBundle mainBundle] pathForResource:@"myfirstbutton" ofType:@"png" inDirectory:@"Buttons"]
                                                             selectedImage: [[NSBundle mainBundle] pathForResource:@"myfirstbutton_selected" ofType:@"png" inDirectory:@"Buttons"]
                                                                     block:^(id sender) {
                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                             [[CCDirector sharedDirector] replaceScene:
                                                                              [CCTransitionFade transitionWithDuration:0.5f scene:[GameModeSelectionScene scene]]];
                                                                         });
                                                                        
                                                                     }
                                       ];
        
        CCMenuItemImage * menuItem2 = [CCMenuItemImage itemFromNormalImage: [[NSBundle mainBundle] pathForResource:@"mysecondbutton" ofType:@"png" inDirectory:@"Buttons"]
                                                             selectedImage: [[NSBundle mainBundle] pathForResource:@"mysecondbutton_selected" ofType:@"png" inDirectory:@"Buttons"]
                                                                     block:^(id sender) {
                                                                         NSLog(@"The second menu was called");
                                                                     }
                                       ];
        
        CCMenuItemImage * menuItem3 = [CCMenuItemImage itemFromNormalImage: [[NSBundle mainBundle] pathForResource:@"mythirdbutton" ofType:@"png" inDirectory:@"Buttons"]
                                                             selectedImage: [[NSBundle mainBundle] pathForResource:@"mythirdbutton_selected" ofType:@"png" inDirectory:@"Buttons"]
                                                                     block:^(id sender) {
                                                                         NSLog(@"The third menu was called");
                                                                     }
                                       ];
                                       
        // Create a menu and add your menu items to it
        CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
        
        // Arrange the menu items vertically
        [myMenu alignItemsVertically];
        
        // add the menu to your scene
        [self addChild:myMenu];
    
    }
    
	return self;
}



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];
    
	[cocosGuy stopAllActions];
	[cocosGuy runAction: [CCMoveTo actionWithDuration:3 position:location]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	cpSpaceFree(space);
	space = NULL;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) onEnter
{
	[super onEnter];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

- (void) nextFrame:(ccTime)dt {
    seeker1.position = ccp( seeker1.position.x + 100*dt, seeker1.position.y );
    if (seeker1.position.x > [[CCDirector sharedDirector] winSize].width+32) {
        seeker1.position = ccp( -32, seeker1.position.y );
    }
}

@end
