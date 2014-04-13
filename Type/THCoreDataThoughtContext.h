//
//  THCoreDataThoughtContext.h
//  Thoughts
//
//  Created by Dom Chapman on 3/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THThoughtContext.h"

@class THCoreDataThought;

@interface THCoreDataThoughtContext : NSObject <THThoughtContext>

-(instancetype)initWithPersistentStoreType:(NSString *)storeType URL:(NSURL *)url;

//Thought parameter of the following methods must relate to thoughts in this context. Else the methods will fail (gracefully).

-(NSString *)uniqueTokenForThought:(THCoreDataThought *)thought;

-(id <THThought>)createThoughtWithSpecification:(THThoughtSpecification *)thoughtSpecification afterThought:(THCoreDataThought *)thought;

-(void)removeThought:(THCoreDataThought *)thought;

@end
