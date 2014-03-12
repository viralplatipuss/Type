//
//  THThoughtsProvider.h
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THThoughtsProvider <NSObject>

-(NSArray *)allThoughts; //Array of NSStrings

@end
