//
//  THThoughtsViewController.h
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THThoughtsProvider.h"

@interface THMainViewController : UIViewController

-(instancetype)initWithThoughtsProvider:(id <THThoughtsProvider>)thoughtsProvider;

@end
