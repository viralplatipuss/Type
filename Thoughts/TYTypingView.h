//
//  TYTypingView.h
//  Type
//
//  Created by Dom Chapman on 3/17/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYTypingView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong, readwrite) UIFont *font;

@property (nonatomic, copy, readwrite) NSString *text;

@end
