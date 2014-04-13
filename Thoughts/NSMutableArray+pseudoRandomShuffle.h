//
//  NSMutableArray+pseudoRandomShuffle.h
//  Type
//
//  Created by Dom Chapman on 3/21/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (pseudoRandomShuffle)

-(void)pseudoRandomShuffleWithSeed:(uint32_t)seed;

@end
