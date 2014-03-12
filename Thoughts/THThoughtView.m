//
//  THThoughtView.m
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THThoughtView.h"

@interface THThoughtView() <UIKeyInput>

@property (nonatomic, strong, readonly) UILabel *textLabel;

@end

@implementation THThoughtView

@synthesize textLabel = _textLabel, delegate = _delegate;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}


#pragma mark - UI

-(void)setupView
{
    self.backgroundColor = [UIColor greenColor];
    
    [self addSubview:self.textLabel];
    
    [self setupConstraints];
}

-(UILabel *)textLabel
{
    if(!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.text = @"";
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _textLabel;
}


#pragma mark - Public Properties

-(void)setThoughtText:(NSString *)thoughtText
{
    if(!thoughtText) {
        thoughtText = @"";
    }
    
    self.textLabel.text = thoughtText;
}

-(NSString *)thoughtText
{
    return self.textLabel.text;
}


#pragma mark - UIKeyInput Methods

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)becomeFirstResponder
{
    [self beginEditing];
    return [super becomeFirstResponder];
}

-(BOOL)hasText
{
    if([self.thoughtText length]) {
        return YES;
    }
    return NO;
}

-(void)insertText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self endEditing];
        return;
    }
    
    self.thoughtText = [self.thoughtText stringByAppendingString:text];
}

-(void)deleteBackward
{
    if([self.thoughtText length] > 0) {
        self.thoughtText = [self.thoughtText substringToIndex:[self.thoughtText length] - 1];
    }
    
    if([self.thoughtText length] == 0) {
        [self endEditing];
    }
    
}

-(void)endEditing
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(thoughtViewShouldEndEditing:)]) {
        if(![self.delegate thoughtViewShouldEndEditing:self]) {
            return;
        }
    }
    
    [self resignFirstResponder];
    self.backgroundColor = [UIColor greenColor];
}

-(void)beginEditing
{
    self.backgroundColor = [UIColor yellowColor];
}


#pragma mark - Constraints

-(void)setupConstraints
{
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"textLabel": self.textLabel};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textLabel]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textLabel]|" options:0 metrics:nil views:views]];
    
}

@end
