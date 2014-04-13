//
//  THThoughtContext.h
//  Thoughts
//
//  Created by Dom Chapman on 3/14/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THThought.h"
#import "THThoughtSpecification.h"

@protocol THThoughtContext <NSObject>

-(id <THThought>)anyThought;

-(id <THThought>)thoughtForUnqiueToken:(NSString *)uniqueToken;

//Will create thought at the end of the chain. Or start the chain if it does not exist.
-(id <THThought>)createThoughtWithSpecification:(THThoughtSpecification *)thoughtSpecification;

@end
