//
//  THCoreDataThought.m
//  Thoughts
//
//  Created by Dom Chapman on 3/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THCoreDataThought.h"

@implementation THCoreDataThought

@dynamic text;
@dynamic nextThought;
@dynamic previousThought;

@synthesize thoughtContext = _thoughtContext;

+(NSString *)coreDataEntityName
{
    return [[THCoreDataThought class] description];
}

-(NSString *)uniqueToken
{
    if(!self.thoughtContext) return nil;
    
    return [self.thoughtContext uniqueTokenForThought:self];
}

-(id <THThought>)createThoughtAfterThisWithSpecification:(THThoughtSpecification *)thoughtSpecification
{
    if(!self.thoughtContext) return nil;
    return [self.thoughtContext createThoughtWithSpecification:thoughtSpecification afterThought:self];
}

-(void)deleteThought
{
    if(!self.thoughtContext) return;
    [self.thoughtContext removeThought:self];
}

-(THCoreDataThought *)nextThought
{
    THCoreDataThought *thought = [self primitiveValueForKey:@"nextThought"];
    thought.thoughtContext = self.thoughtContext;
    
    return thought;
}

-(THCoreDataThought *)previousThought
{
    THCoreDataThought *thought = [self primitiveValueForKey:@"previousThought"];
    thought.thoughtContext = self.thoughtContext;
    
    return thought;
}

@end
