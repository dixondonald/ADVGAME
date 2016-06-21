//
//  GlobalData.m
//  ADVGAME
//
//  Created by Ziggy on 6/8/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import "GlobalData.h"


@implementation GlobalData

@synthesize startingText ,inventory, currentArray, commands, alleyInvestigates, alleyTalks, vagrantTalks, alleyMoves, candyBarActions, crowbarActions ,vagrantIsAwake, vagrantIsGone, vagrantHasEaten, fenceIsOpen, barInvestigates, barTalks, bartenderTalks, barMoves, walletActions, tabIsKnown, backDoorIsUnlocked, restroomIsUnlocked, restroomInvestigates, restroomTalks, restroomMoves, bugSprayActions, bugSprayIsTaken;
+(GlobalData *)globalData {
    static dispatch_once_t pred;
    static GlobalData *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[GlobalData alloc] init];
        shared.startingText = @"You wake in an alley. You don't know where you are or how you got here.";
        shared.inventory = [[NSMutableArray alloc]initWithObjects:@"<", @"Candybar >", nil];
        shared.commands = [[NSMutableArray alloc] initWithObjects:@"LOOK AROUND", nil];
        
        shared.alleyInvestigates = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.alleyTalks = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.vagrantTalks = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.alleyMoves = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.candyBarActions = [[NSMutableArray alloc] initWithObjects:@"<", @"Inspect Candybar", @"Eat Candybar", @"Give Candybar to Vagrant", nil];
        shared.crowbarActions = [[NSMutableArray alloc] initWithObjects:@"<", @"Use Crowbar on Fence", nil];
        shared.vagrantIsAwake = NO;
        shared.vagrantIsGone = NO;
        shared.vagrantHasEaten = NO;
        shared.fenceIsOpen = NO;

    
        shared.barInvestigates = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.barTalks = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.bartenderTalks = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.barMoves= [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.walletActions = [[NSMutableArray alloc] initWithObjects:@"<", @"Pay Tab", nil];
        shared.tabIsKnown = NO;
        shared.backDoorIsUnlocked = NO;
        shared.restroomIsUnlocked = NO;
        
        shared.restroomInvestigates = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.restroomTalks = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.restroomMoves = [[NSMutableArray alloc] initWithObjects:@"<", @"Back to Bar", nil];
        shared.bugSprayActions = [[NSMutableArray alloc] initWithObjects:@"<", @"Use Bug Spray on Vagrant", nil];
        shared.bugSprayIsTaken = NO;





    });
    return shared;
}





@end
