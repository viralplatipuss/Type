//
//  NSMutableArray+pseudoRandomShuffle.m
//  Type
//
//  Created by Dom Chapman on 3/21/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "NSMutableArray+pseudoRandomShuffle.h"
#import "MTRandom.h"

@implementation NSMutableArray (pseudoRandomShuffle)

-(void)pseudoRandomShuffleWithSeed:(uint32_t)seed
{
    MTRandom *random = [[MTRandom alloc] initWithSeed:seed];
    
    uint32_t maxIndex = (uint32_t)[self count]-1;
    
    for (uint32_t currentIndex=0; currentIndex<maxIndex; currentIndex++) {
        
        uint32_t randomIndex = [random randomUInt32From:currentIndex to:maxIndex];
        
        if(currentIndex != randomIndex) {
            [self exchangeObjectAtIndex:currentIndex withObjectAtIndex:randomIndex];
        }
    }
}

@end
