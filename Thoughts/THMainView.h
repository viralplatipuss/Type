//
//  THMainView.h
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THThoughtView.h"

@interface THMainView : UIView

@property (nonatomic, strong, readonly) THThoughtView *thoughtView;

@property (nonatomic, strong, readonly) UIScrollView *emptyScrollView;

@end
