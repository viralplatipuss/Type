//
//  TYCoreDataThought.m
//  Type
//
//  Created by Dom Chapman on 3/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYCoreDataThought.h"

@implementation TYCoreDataThought

@dynamic text;
@dynamic nextThought;
@dynamic previousThought;

@synthesize thoughtContext = _thoughtContext;

+(NSString *)coreDataEntityName
{
    return [[TYCoreDataThought class] description];
}

-(NSString *)uniqueToken
{
    if(!self.thoughtContext) return nil;
    
    return [self.thoughtContext uniqueTokenForThought:self];
}

-(id <TYThought>)createThoughtAfterThisWithSpecification:(TYThoughtSpecification *)thoughtSpecification
{
    if(!self.thoughtContext) return nil;
    return [self.thoughtContext createThoughtWithSpecification:thoughtSpecification afterThought:self];
}

-(void)deleteThought
{
    if(!self.thoughtContext) return;
    [self.thoughtContext removeThought:self];
}

-(TYCoreDataThought *)nextThought
{
    TYCoreDataThought *thought = [self primitiveValueForKey:@"nextThought"];
    thought.thoughtContext = self.thoughtContext;
    
    return thought;
}

-(TYCoreDataThought *)previousThought
{
    TYCoreDataThought *thought = [self primitiveValueForKey:@"previousThought"];
    thought.thoughtContext = self.thoughtContext;
    
    return thought;
}

@end
