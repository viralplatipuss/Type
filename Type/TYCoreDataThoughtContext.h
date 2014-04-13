//
//  TYCoreDataThoughtContext.h
//  Type
//
//  Created by Dom Chapman on 3/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYThoughtContext.h"

@class TYCoreDataThought;

@interface TYCoreDataThoughtContext : NSObject <TYThoughtContext>

-(instancetype)initWithPersistentStoreType:(NSString *)storeType URL:(NSURL *)url;

//Thought parameter of the following methods must relate to thoughts in this context. Else the methods will fail (gracefully).

-(NSString *)uniqueTokenForThought:(TYCoreDataThought *)thought;

-(id <TYThought>)createThoughtWithSpecification:(TYThoughtSpecification *)thoughtSpecification afterThought:(TYCoreDataThought *)thought;

-(void)removeThought:(TYCoreDataThought *)thought;

@end
