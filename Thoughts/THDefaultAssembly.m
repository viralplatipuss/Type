//
//  THDefaultAssembly.m
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THDefaultAssembly.h"
#import "THMainViewController.h"
#import "THCoreDataThoughtContext.h"


static NSString * const kCoreDataThoughtContextSQLDBName = @"Thoughts";


@interface THDefaultAssembly()

@property (nonatomic, strong, readonly) id <THThoughtContext> thoughtContext;

@end

@implementation THDefaultAssembly

@synthesize viewController = _viewController, thoughtContext = _thoughtContext;

-(UIViewController *)viewController
{
    if(!_viewController) {
        _viewController = [[THMainViewController alloc] initWithThoughtContext:self.thoughtContext];
    }
    
    return _viewController;
}

-(id <THThoughtContext>)thoughtContext
{
    if(!_thoughtContext) {
        _thoughtContext = [[THCoreDataThoughtContext alloc] initWithCoreDataSQLDatabaseName:kCoreDataThoughtContextSQLDBName];
    }
    
    return _thoughtContext;
}

@end
