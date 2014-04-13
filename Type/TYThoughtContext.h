//
//  TYThoughtContext.h
//  Type
//
//  Created by Dom Chapman on 3/14/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYThought.h"
#import "TYThoughtSpecification.h"

@protocol TYThoughtContext <NSObject>

-(id <TYThought>)anyThought;

-(id <TYThought>)thoughtForUnqiueToken:(NSString *)uniqueToken;

//Will create thought at the end of the chain. Or start the chain if it does not exist.
-(id <TYThought>)createThoughtWithSpecification:(TYThoughtSpecification *)thoughtSpecification;

@end
