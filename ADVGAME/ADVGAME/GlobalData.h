//
//  GlobalData.h
//  ADVGAME
//
//  Created by Ziggy on 6/8/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GlobalData : NSObject
@property (nonatomic, retain) NSString *startingText;
@property (nonatomic, retain) NSMutableArray *inventory;
@property (nonatomic, retain) NSArray *currentArray;
@property (nonatomic, retain) NSMutableArray *commands;

@property (nonatomic, retain) NSMutableArray *alleyInvestigates;
@property (nonatomic, retain) NSMutableArray *alleyTalks;
@property (nonatomic, retain) NSMutableArray *vagrantTalks;
@property (nonatomic, retain) NSMutableArray *alleyMoves;
@property (nonatomic, retain) NSMutableArray *candyBarActions;
@property (nonatomic, retain) NSMutableArray *crowbarActions;
@property (nonatomic) BOOL vagrantIsAwake;
@property (nonatomic) BOOL vagrantIsGone;
@property (nonatomic) BOOL vagrantHasEaten;
@property (nonatomic) BOOL fenceIsOpen;

@property (nonatomic, retain) NSMutableArray *barInvestigates;
@property (nonatomic, retain) NSMutableArray *barTalks;
@property (nonatomic, retain) NSMutableArray *bartenderTalks;
@property (nonatomic, retain) NSMutableArray *barMoves;
@property (nonatomic, retain) NSMutableArray *walletActions;
@property (nonatomic) BOOL tabIsKnown;
@property (nonatomic) BOOL backDoorIsUnlocked;
@property (nonatomic) BOOL restroomIsUnlocked;


@property (nonatomic, retain) NSMutableArray *restroomInvestigates;
@property (nonatomic, retain) NSMutableArray *restroomTalks;
@property (nonatomic, retain) NSMutableArray *restroomMoves;
@property (nonatomic, retain) NSMutableArray *bugSprayActions;
@property (nonatomic) BOOL bugSprayIsTaken;










+(GlobalData*)globalData;

@end
