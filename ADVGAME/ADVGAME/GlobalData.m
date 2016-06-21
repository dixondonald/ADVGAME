//
//  GlobalData.m
//  ADVGAME
//
//  Created by Ziggy on 6/8/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import "GlobalData.h"


@implementation GlobalData

@synthesize startingText ,inventory, currentArray, commands, alleyInvestigates, alleyTalks, vagrantTalks, alleyMoves, candyBarActions, vagrantIsAwake, vagrantIsGone, vagrantHasEaten, barInvestigates, barTalks, barMoves, backDoorIsUnlocked;
+(GlobalData *)globalData {
    static dispatch_once_t pred;
    static GlobalData *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[GlobalData alloc] init];
        shared.startingText = @"You wake in an alley. You don't know where you are or how you got here.";
        shared.inventory = [[NSMutableArray alloc]initWithObjects:@"<", @"Candybar", nil];
        shared.commands = [[NSMutableArray alloc] initWithObjects:@"LOOK AROUND", nil];
        
        shared.alleyInvestigates = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.alleyTalks = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.vagrantTalks = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.alleyMoves = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.candyBarActions = [[NSMutableArray alloc] initWithObjects:@"<", @"Inspect Candybar", @"Eat Candybar", @"Give Candybar to Vagrant", nil];
        shared.vagrantIsAwake = NO;
        shared.vagrantIsGone = NO;
        shared.vagrantHasEaten = NO;

        shared.barInvestigates = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.barTalks = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.barMoves = [[NSMutableArray alloc] initWithObjects:@"<", nil];
        shared.backDoorIsUnlocked = NO;

    });
    return shared;
}





@end
