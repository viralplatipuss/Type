//
//  TYMainView.h
//  Type
//
//  Created by Dom Chapman on 3/17/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTypingView.h"

@interface TYMainView : UIView

@property (nonatomic, strong, readonly) UILabel *toolTipLabel;

@property (nonatomic, strong, readonly) TYTypingView *typingView;

@end
