//
//  TYSlidingTextPositionView.h
//  Type
//
//  Created by Dom Chapman on 4/6/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

/*

 NOTES
 
    -   Will transition text from one position to another (keeping same text alignment).
 
    -   Uses a custom form of elastic-ease-out easing, where each character in the text
        move independently of each other.
 
 TODO
 
    -   Add support for other text positions and alignments.
 
*/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TYSlidingTextPositionTransitionViewTextPosition) {
    TYSlidingTextPositionTransitionViewTextPositionLeft,
    TYSlidingTextPositionTransitionViewTextPositionCenter
};

@interface TYSlidingTextPositionTransitionView : UIView


//Text properties

@property (nonatomic, copy, readwrite) NSString *text;

@property (nonatomic, strong, readwrite) UIFont *font;

@property (nonatomic, strong, readwrite) UIColor *textColor;

@property (nonatomic, assign, readwrite) CGFloat preferredMaxLayoutWidth;


//Transition Control

//Value between 0-1
@property (nonatomic, assign, readwrite) CGFloat transitionProgress;

@property (nonatomic, assign, readwrite) TYSlidingTextPositionTransitionViewTextPosition startPosition;

@property (nonatomic, assign, readwrite) TYSlidingTextPositionTransitionViewTextPosition endPosition;


//Use the following properties if you need the text to be slightly off-position.
@property (nonatomic, assign, readwrite) CGFloat startTextInsetX;

@property (nonatomic, assign, readwrite) CGFloat endTextInsetX;

@end
