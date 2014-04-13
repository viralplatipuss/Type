//
//  TYMainViewController.h
//  Type
//
//  Created by Dom Chapman on 4/7/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THThoughtContext.h"

@interface TYMainViewController : UIViewController

-(instancetype)initWithThoughtContext:(id<THThoughtContext>)thoughtContext;

@end
