//
//  Thought.h
//  Thoughts
//
//  Created by Dom Chapman on 3/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Thought : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Thought *nextThought;
@property (nonatomic, retain) Thought *previousThought;

@end
