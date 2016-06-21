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
@property (nonatomic) BOOL vagrantIsAwake;
@property (nonatomic) BOOL vagrantIsGone;
@property (nonatomic) BOOL vagrantHasEaten;

@property (nonatomic, retain) NSMutableArray *barInvestigates;
@property (nonatomic, retain) NSMutableArray *barTalks;
@property (nonatomic, retain) NSMutableArray *barMoves;
@property (nonatomic) BOOL backDoorIsUnlocked;







+(GlobalData*)globalData;

@end
