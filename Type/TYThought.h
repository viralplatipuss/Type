//
//  TYThought.h
//  Type
//
//  Created by Dom Chapman on 3/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYThoughtSpecification.h"

@protocol TYThought <NSObject>

@property (nonatomic, copy, readonly) NSString *text;

@property (nonatomic, strong, readonly) id <TYThought> nextThought;

@property (nonatomic, strong, readonly) id <TYThought> previousThought;


-(NSString *)uniqueToken;


-(id <TYThought>)createThoughtAfterThisWithSpecification:(TYThoughtSpecification *)thoughtSpecification;

-(void)deleteThought;

@end
