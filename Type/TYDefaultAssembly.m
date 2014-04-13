//
//  TYDefaultAssembly.m
//  Type
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYDefaultAssembly.h"
#import "TYCoreDataThoughtContext.h"
#import "TYUserDefaultsStringPersistor.h"

#import "TYMainViewController.h"


//Constants
static NSString * const kCoreDataThoughtContextSQLDBName = @"Thoughts.sqlite";

static NSString * const kThoughtTokenUserDefaultsKey = @"thoughtToken";


@interface TYDefaultAssembly()

@property (nonatomic, strong, readonly) id <TYThoughtContext> thoughtContext;

@property (nonatomic, strong, readonly) id <TYStringPersistor> thoughtTokenPersistor;

@end

@implementation TYDefaultAssembly

@synthesize viewController = _viewController,
            thoughtContext = _thoughtContext,
            thoughtTokenPersistor = _thoughtTokenPersistor;


-(UIViewController *)viewController
{
    if(!_viewController) {
        _viewController = [[TYMainViewController alloc] initWithThoughtContext:self.thoughtContext thoughtTokenPersistor:self.thoughtTokenPersistor];
    }
    
    return _viewController;
}

-(id <TYThoughtContext>)thoughtContext
{
    if(!_thoughtContext) {
        NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *coreDataSQLDatabaseURL = [applicationDocumentsDirectory URLByAppendingPathComponent:kCoreDataThoughtContextSQLDBName];
        
        _thoughtContext = [[TYCoreDataThoughtContext alloc] initWithPersistentStoreType:NSSQLiteStoreType URL:coreDataSQLDatabaseURL];
    }
    
    return _thoughtContext;
}

-(id <TYStringPersistor>)thoughtTokenPersistor
{
    if(!_thoughtTokenPersistor) {
        _thoughtTokenPersistor = [[TYUserDefaultsStringPersistor alloc] initWithKey:kThoughtTokenUserDefaultsKey];
    }
    
    return _thoughtTokenPersistor;
}

@end