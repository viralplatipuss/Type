//
//  TYMainView.h
//  Type
//
//  Created by Dom Chapman on 4/10/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSharedCharactersTransitionView.h"
#import "TYSlidingTextPositionTransitionView.h"
#import "TYScrollingTrackerView.h"

@interface TYMainView : UIView


-(instancetype)init;

//Views
@property (nonatomic, strong, readonly) UIView *headerView;

@property (nonatomic, strong, readonly) UITextView *textView;

@property (nonatomic, strong, readonly) TYSharedCharactersTransitionView *transitionView;

@property (nonatomic, strong, readonly) TYSlidingTextPositionTransitionView *textSlidingView;

@property (nonatomic, strong, readonly) TYScrollingTrackerView *scrollingTrackerView;

//Labels
@property (nonatomic, strong, readonly) UILabel *headerLabel;

@property (nonatomic, strong, readonly) UILabel *clearLabel;

@property (nonatomic, strong, readonly) UILabel *characterCountLabel;


//Constraints
@property (nonatomic, strong, readonly) NSLayoutConstraint *contentViewBottomConstraint;


//Extra properties

@property (nonatomic, strong, readonly) UIColor *clearHeaderColor;

@property (nonatomic, assign, readonly) CGFloat textViewPaddingX;

/*  Useful if you want to account for showing the view with/without status bar. (Keeping header color beneath it)   */
@property (nonatomic, assign, readwrite) CGFloat headerInset;


@end
