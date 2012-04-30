//
//  SinglePlayerScene.m
//  Conquer
//
//  Created by Steve Johnson on 4/23/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "Constants.h"
#import "SinglePlayerScene.h"
#import "Map.h"
#import "Territory.h"
#import "Player.h"
#import "HumanPlayer.h"
#import "GameWonScene.h"

#import "UIColor_ColorFromUInt32.h"
#import "NSMutableArray_Shuffling.h"

@implementation SinglePlayerScene

@interface Map (PrivateAPI)
- (void) gameLoop;
@end

-(id) init {

	if ((self = [super init])) {
        

        self.isTouchEnabled = true;

		CGSize winSize = [[CCDirector sharedDirector] winSize];

		//setup the basic scene
		
		CCSprite* mapBackground = [CCSprite spriteWithFile:@"Maps/Background.png"];
		mapBackground.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:mapBackground z:-10];
		
		CCSprite* hud = [CCSprite spriteWithFile:@"HUD/SinglePlayer.png"];
		hud.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:hud z:10];
        
        labelCurrentPlayerName = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:24];
        labelCurrentPlayerName.position = ccp(winSize.width/2, 50);
        [hud addChild: labelCurrentPlayerName];
        labelCurrentPlayerState = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:24];
        labelCurrentPlayerState.position = ccp(winSize.width/2, 20);
        [hud addChild: labelCurrentPlayerState];

		
        //load the map
		map = [[Map alloc] initWithMapName:@"Conquer" andHudLayer:hud];
		[self addChild:[map displayNode] z:-1];
		
        //create the players
		players = [[NSMutableArray alloc] init];
        [players addObject:[[HumanPlayer alloc] initWithName:@"Steve" andColor:(255) + (0<<8) + (0<<16) + (255<<24)]];
        [players addObject:[[HumanPlayer alloc] initWithName:@"Bobble" andColor:(0) + (255<<8) + (0<<16) + (255<<24)]];
        currentPlayerIndex = 0;
		
        
        uint playerIndex = 0;
        NSMutableArray* unassignedTerritories = [[NSMutableArray alloc] initWithArray:[map territories]];
        [unassignedTerritories shuffle];
        
        //assign territories to players randomly
        for(Territory* unassignedTerritory in unassignedTerritories) {
            unassignedTerritory.owner = [players objectAtIndex:playerIndex];
            playerIndex = (playerIndex+1)%[players count];
        }
        

        //start the game!
        isGameOver = false;
        [self schedule:@selector(gameLoop:)];

        NSLog(@"SinglePlayerScene created");

	}
	
	
	return self;
}

-(void) cleanup {
    [self unscheduleAllSelectors];
    players = nil;
    [map cleanup];
    NSLog(@"Cleaned up SinglePlayerScene");
}

- (void) gameLoop: (ccTime) dT {
    if(isGameOver) {
        return;
    }
    
    //check win condition
    unsigned int loserCount = 0;
    for(Player* player in players) {
        if(player.state == STATE_GAME_LOST) {
            loserCount++;
        }
    }
    if(loserCount == [players count]-1) {
        NSLog(@"Game is over - checking for winner");
        //game is over yo
        for(Player* player in players) {
            if(player.state != STATE_GAME_LOST) {
                //winna winna!
                
                
                dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
                dispatch_queue_t queue = dispatch_get_main_queue();
                
                dispatch_after(delay, queue, ^{
                    [[CCDirector sharedDirector] replaceScene: [CCTransitionFlipAngular transitionWithDuration:0.5f scene:[GameWonScene scene]]];
                });
                
                NSLog(@"Winner is %@", player.name);
            }
        }
        [self cleanup];
        isGameOver = true;
        return;
    }
    
    
    Player* currentPlayer = [players objectAtIndex:currentPlayerIndex];
    if(currentPlayer.state == STATE_GAME_LOST) {
        //skip over the losers
        currentPlayer = [self nextPlayer];
    }else if(currentPlayer.state == STATE_GAME_NOT_STARTED) {
        //do any setup required on a player-by-player level
        currentPlayer.state = STATE_IDLE;
    }else if(currentPlayer.state == STATE_IDLE) {
        
        //time to move!
        int armies = map.armiesPerTurn;
        int territoriesOwned = 0;
        for(Territory* territory in map.territories) {
            if(territory.owner == currentPlayer) {
                territoriesOwned++;
            }
        }
        currentPlayer.armiesToPlace+= armies + (territoriesOwned/map.territoriesForAdditionalArmyPerTurn);

        currentPlayer.state = STATE_PLACING;
        [currentPlayer place];
    }else if(currentPlayer.state == STATE_HAS_PLACED) {
        currentPlayer.state = STATE_ATTACKING;
        [currentPlayer attack];
    }else if(currentPlayer.state == STATE_HAS_ATTACKED) {
        currentPlayer.state = STATE_FORTIFYING;
        [currentPlayer fortify];
    }else if(currentPlayer.state == STATE_HAS_FORTIFIED) {
        currentPlayer.state = STATE_IDLE;
        [self nextPlayer];
    }
}

-(Player* )nextPlayer {
    
    Player* currentPlayer = [players objectAtIndex:currentPlayerIndex];
    currentPlayer.originTerritory = nil;
    currentPlayer.destinationTerritory = nil;
    
    currentPlayerIndex = (currentPlayerIndex+1)%[players count];
    return [players objectAtIndex:currentPlayerIndex];   
}



-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
    // get the position in tile coordinates from the touch location
    Player* currentPlayer = [players objectAtIndex:currentPlayerIndex];
    Territory* touchedTerritory = [map territoryAtTouch:[touches anyObject]];
    
    [currentPlayer touchedTerritory: touchedTerritory];
}

-(void) draw {
    Player* currentPlayer = [players objectAtIndex:currentPlayerIndex];
    
    //highlight territories by player
    for(Territory* territory in [map territories]) {
        [territory highlightWithColor:territory.owner.color];
    }
    
    //show the current player's selections
    if(currentPlayer.originTerritory != nil) {
        [currentPlayer.originTerritory selectWithColor:(0) + (255<<8) + (255<<16) + (255<<24)];
    }
    if(currentPlayer.destinationTerritory != nil) {
        [currentPlayer.destinationTerritory selectWithColor:(255) + (0<<8) + (255<<16) + (255<<24)];
    }
    
    //show the current player status
    labelCurrentPlayerName.color = ccc3(currentPlayer.color&0xFF, (currentPlayer.color>>8)&0xFF, (currentPlayer.color>>16)&0xFF);
    [labelCurrentPlayerName setString:currentPlayer.name];
    [labelCurrentPlayerState setString:currentPlayer.stateDescription];
}

@end
