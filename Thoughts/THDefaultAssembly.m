//
//  THDefaultAssembly.m
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THDefaultAssembly.h"
#import "THThoughtsViewController.h"

@implementation THDefaultAssembly

@synthesize viewController = _viewController;

-(UIViewController *)viewController
{
    if(!_viewController) {
        _viewController = [[THThoughtsViewController alloc] init];
    }
    
    return _viewController;
}

@end
