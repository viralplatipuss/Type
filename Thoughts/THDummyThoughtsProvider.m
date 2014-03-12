//
//  THDummyThoughtsProvider.m
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THDummyThoughtsProvider.h"

@implementation THDummyThoughtsProvider

-(NSArray *)allThoughts
{
    NSArray *thoughts = @[@"Portfolio Apps",
                          @"Gym",
                          @"Learning Chinese"
                          ];
    
    return thoughts;
}

@end
