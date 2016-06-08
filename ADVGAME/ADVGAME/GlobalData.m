//
//  GlobalData.m
//  ADVGAME
//
//  Created by Ziggy on 6/8/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import "GlobalData.h"


@implementation GlobalData

@synthesize inventory;
+(GlobalData *)globalData {
    static dispatch_once_t pred;
    static GlobalData *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[GlobalData alloc] init];
        shared.inventory = [[NSMutableArray alloc]initWithObjects:@"<", @"Candybar", nil];
    });
    return shared;
}





@end
