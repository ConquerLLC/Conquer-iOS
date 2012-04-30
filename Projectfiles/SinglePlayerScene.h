//
//  SinglePlayerScene.h
//  Conquer
//
//  Created by Steve Johnson on 4/23/12.
//  Copyright 2012 Conquer, LLC. All rights reserved.
//

#import "cocos2d.h"
#import "LayerBase.h"

@class Map;
@class Player;

@interface SinglePlayerScene : LayerBase
{
	Map* map;
    
    CCLabelTTF* labelCurrentPlayerName;
    CCLabelTTF* labelCurrentPlayerState;
    CCLabelTTF* labelCurrentPlayerTurnTimer;
    
    
    NSMutableArray* players;
    int currentPlayerIndex;
    
    BOOL isGameOver;
    ccTime secondsRemainingInTurn;
    int initialSecondsInTurn;
}

-(Player* )nextPlayer;

@end
