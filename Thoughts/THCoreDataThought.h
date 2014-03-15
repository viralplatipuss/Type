//
//  THCoreDataThought.h
//  Thoughts
//
//  Created by Dom Chapman on 3/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "THCoreDataThoughtContext.h"

@interface THCoreDataThought : NSManagedObject <THThought>

@property (nonatomic, copy, readwrite) NSString *text;

@property (nonatomic, strong, readwrite) THCoreDataThought *nextThought;

@property (nonatomic, strong, readwrite) THCoreDataThought *previousThought;

@property (nonatomic, strong, readwrite) THCoreDataThoughtContext *thoughtContext; //strong?

+(NSString *)coreDataEntityName;

@end
