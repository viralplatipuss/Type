//
//  THDefaultAssembly.m
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THDefaultAssembly.h"
#import "THCoreDataThoughtContext.h"
#import "TYMainViewController.h"


//Constants
static NSString * const kCoreDataThoughtContextSQLDBName = @"Thoughts.sqlite";


@interface THDefaultAssembly()

@property (nonatomic, strong, readonly) id <THThoughtContext> thoughtContext;

@end

@implementation THDefaultAssembly

@synthesize viewController = _viewController, thoughtContext = _thoughtContext;

-(UIViewController *)viewController
{
    if(!_viewController) {
        _viewController = [[TYMainViewController alloc] initWithThoughtContext:self.thoughtContext];
    }
    
    return _viewController;
}

-(id <THThoughtContext>)thoughtContext
{
    if(!_thoughtContext) {
        NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *coreDataSQLDatabaseURL = [applicationDocumentsDirectory URLByAppendingPathComponent:kCoreDataThoughtContextSQLDBName];
        
        _thoughtContext = [[THCoreDataThoughtContext alloc] initWithPersistentStoreType:NSSQLiteStoreType URL:coreDataSQLDatabaseURL];
    }
    
    return _thoughtContext;
}

@end