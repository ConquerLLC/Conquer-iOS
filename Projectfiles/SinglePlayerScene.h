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
    
    CCLabelTTF* labelOriginTerritory;
    CCLabelTTF* labelCurrentPlayerName;
    CCLabelTTF* labelCurrentPlayerState;
    
    
    NSMutableArray* players;
    int currentPlayerIndex;
    BOOL isGameOver;
}

-(Player* )nextPlayer;

@end
