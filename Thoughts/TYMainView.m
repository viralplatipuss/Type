//
//  TYMainView.m
//  Type
//
//  Created by Dom Chapman on 3/17/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYMainView.h"
#import "UIColor+HexString.h"

static NSString * const kBackgroundColor = @"3497da";

static NSString * const kApplicationFontName = @"Raleway-Light";

static const CGFloat kToolTipFontSize = 12;


@interface TYMainView()

@property (nonatomic, strong, readonly) UIView *topLine;

@property (nonatomic, strong, readwrite) NSLayoutConstraint *containerViewBottomConstraint;

@end

@implementation TYMainView

@synthesize topLine = _topLine, toolTipLabel = _toolTipLabel, typingView = _typingView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self registerForKeyboardNotifications];
    }
    return self;
}

-(void)setupView
{
    self.backgroundColor = [UIColor colorWithHexString:kBackgroundColor];
    
    [self addSubview:self.topLine];
    [self addSubview:self.toolTipLabel];
    [self addSubview:self.typingView];
    
    [self setupConstraints];
}

-(UIView *)topLine
{
    if(!_topLine) {
        _topLine = [UIView new];
        _topLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    }
    
    return _topLine;
}

-(TYTypingView *)typingView
{
    if(!_typingView) {
        _typingView = [TYTypingView new];
        _typingView.font = [UIFont fontWithName:kApplicationFontName size:36];
    }
    
    return _typingView;
}

-(UILabel *)toolTipLabel
{
    if(!_toolTipLabel) {
        _toolTipLabel = [UILabel new];
        _toolTipLabel.textAlignment = NSTextAlignmentCenter;
        _toolTipLabel.font = [UIFont fontWithName:kApplicationFontName size:kToolTipFontSize];
        _toolTipLabel.textColor = [UIColor colorWithRed:0/255.0 green:47/255.0 blue:181/255.0 alpha:1];
    }
    
    return _toolTipLabel;
}

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSNumber *animationDurationNumber = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat animationDuration = [animationDurationNumber floatValue];
    
    [self layoutIfNeeded];
    self.containerViewBottomConstraint.constant = -keyboardSize.height-10;
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self layoutIfNeeded];
        
    } completion:nil];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    
    NSNumber *animationDurationNumber = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat animationDuration = [animationDurationNumber floatValue];
    
    [self layoutIfNeeded];
    self.containerViewBottomConstraint.constant = -10;
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self layoutIfNeeded];
        
    } completion:nil];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setupConstraints
{
    
    self.topLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolTipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.typingView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"topLine": self.topLine,
                            @"toolTipLabel": self.toolTipLabel,
                            @"typingView": self.typingView};
    
    NSDictionary *metrics = @{@"topLineOffsetY": @(51),
                              @"topLineThickness":@(0.5),
                              @"toolTipOffsetY":@(27.5)};
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topLine]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topLineOffsetY-[topLine(topLineThickness)]" options:0 metrics:metrics views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolTipLabel]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-toolTipOffsetY-[toolTipLabel]" options:0 metrics:metrics views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[typingView]-10-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLine]-10-[typingView]" options:0 metrics:metrics views:views]];
    
    
    
    self.containerViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.typingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    
    [self addConstraint:self.containerViewBottomConstraint];
    
}

@end
