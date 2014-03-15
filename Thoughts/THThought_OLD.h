//
//  THThought.h
//  Thoughts
//
//  Created by Dom Chapman on 3/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THThought <NSObject>

@property (nonatomic, copy, readonly) NSString *text;

@property (nonatomic, strong, readonly) id <THThought> nextThought;

@property (nonatomic, strong, readonly) id <THThought> previousThought;

-(id <THThought>)insertNewThoughtAfterThisWithText:(NSString *)text;

@end
