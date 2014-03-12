//
//  THDummyThoughtsProvider.m
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THDummyThoughtsProvider.h"

@implementation THDummyThoughtsProvider

-(NSString *)thoughtForUid:(NSUInteger)uid
{
    switch (uid) {
        case 0:
            return @"Portfolio Apps";
        case 1:
            return @"Gym";
        case 2:
            return @"Learning Chinese";
        default:
            return nil;
    }
}

-(NSUInteger)totalThoughts
{
    return 3;
}

@end
