//
//  GlobalData.h
//  ADVGAME
//
//  Created by Ziggy on 6/8/16.
//  Copyright © 2016 DonaldDixon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GlobalData : NSObject@property (nonatomic, retain)
NSMutableArray *inventory;

+(GlobalData*)globalData;

@end
