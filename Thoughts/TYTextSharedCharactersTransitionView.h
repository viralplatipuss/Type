//
//  TYTextSharedCharactersTransitionView.h
//  Type
//
//  Created by Dom Chapman on 3/20/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYTextSharedCharactersTransitionView : UIView

-(instancetype)init;

@property (nonatomic, copy, readwrite) NSString *startText;

@property (nonatomic, copy, readwrite) NSString *endText;

@property (nonatomic, strong, readwrite) UIFont *font;

@property (nonatomic, strong, readwrite) UIColor *textColor;

//Value between 0-1 to set the transition progress.
@property (nonatomic, assign, readwrite) CGFloat transitionAmount;

@end
