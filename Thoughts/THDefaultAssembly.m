//
//  THDefaultAssembly.m
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THDefaultAssembly.h"
#import "THMainViewController.h"
#import "THDummyThoughtsProvider.h"

@interface THDefaultAssembly()

@property (nonatomic, strong, readonly) id <THThoughtsProvider> thoughtsProvider;

@end

@implementation THDefaultAssembly

@synthesize viewController = _viewController, thoughtsProvider = _thoughtsProvider;

-(id <THThoughtsProvider>)thoughtsProvider
{
    if(!_thoughtsProvider) {
        _thoughtsProvider = [[THDummyThoughtsProvider alloc] init];
    }
    
    return _thoughtsProvider;
}

-(UIViewController *)viewController
{
    if(!_viewController) {
        _viewController = [[THMainViewController alloc] initWithThoughtsProvider:self.thoughtsProvider];
    }
    
    return _viewController;
}

@end
