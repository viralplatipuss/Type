//
//  THThoughtView.h
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THThoughtViewDelegate;

@interface THThoughtView : UIView

@property (nonatomic, copy, readwrite) NSString *thoughtText;

@property (nonatomic, weak, readwrite) id <THThoughtViewDelegate> delegate;

@end

@protocol THThoughtViewDelegate <NSObject>

@optional
-(BOOL)thoughtViewShouldEndEditing:(THThoughtView *)thoughtView;

@end