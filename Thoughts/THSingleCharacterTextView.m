//
//  THTextEntryView.m
//  Thoughts
//
//  Created by Dom Chapman on 3/15/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THSingleCharacterTextView.h"

@interface THSingleCharacterTextView()

@property (nonatomic, strong, readonly) UILabel *fullTextLabel;

@property (nonatomic, strong, readonly) NSMutableArray *characters;

@end

@implementation THSingleCharacterTextView

@synthesize fullTextLabel = _fullTextLabel, characters;

-(instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    self.backgroundColor = [UIColor greenColor];
    
    self.fullTextLabel.backgroundColor = [UIColor yellowColor];
    
    [self addSubview:self.fullTextLabel];
    
    
    [self setupConstraints];
}

-(UILabel *)fullTextLabel
{
    if(!_fullTextLabel) {
        _fullTextLabel = [UILabel new];
        _fullTextLabel.numberOfLines = 0;
    }
    
    return _fullTextLabel;
}

-(void)setText:(NSString *)text
{
    self.fullTextLabel.text = text;
    [self.fullTextLabel sizeToFit];
}

-(void)setupConstraints
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.fullTextLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.fullTextLabel attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
}

@end
