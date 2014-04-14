//
//  TYCoreDataThought.h
//  Type
//
//  Created by Dom Chapman on 3/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TYThought.h"

@class TYCoreDataThoughtContext;

@interface TYCoreDataThought : NSManagedObject <TYThought>

@property (nonatomic, copy, readwrite) NSString *text;

@property (nonatomic, strong, readwrite) TYCoreDataThought *nextThought;

@property (nonatomic, strong, readwrite) TYCoreDataThought *previousThought;

@property (nonatomic, strong, readwrite) TYCoreDataThoughtContext *thoughtContext;


+(NSString *)coreDataEntityName;

@end
