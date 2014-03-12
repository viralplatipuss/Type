//
//  THMainView.m
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THMainView.h"

@interface THMainView()

@end

@implementation THMainView

@synthesize thoughtView = _thoughtView, emptyScrollView = _emptyScrollView;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    [self addSubview:self.thoughtView];
    [self addSubview:self.emptyScrollView];

    [self setupConstraints];
}

-(THThoughtView *)thoughtView
{
    if(!_thoughtView) {
        _thoughtView = [[THThoughtView alloc] initWithFrame:CGRectZero];
    }
    
    return _thoughtView;
}

-(UIScrollView *)emptyScrollView
{
    if(!_emptyScrollView) {
        _emptyScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _emptyScrollView.pagingEnabled = YES;
        
        //TEMP
        CGSize size = [UIScreen mainScreen].bounds.size;
        size.width *= 2;
        _emptyScrollView.contentSize = size;
    }
    
    return _emptyScrollView;
}

-(void)setupConstraints
{
    self.thoughtView.translatesAutoresizingMaskIntoConstraints = NO;
    self.emptyScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"thoughtView": self.thoughtView,
                            @"emptyScrollView": self.emptyScrollView};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[thoughtView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[thoughtView]|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[emptyScrollView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[emptyScrollView]|" options:0 metrics:nil views:views]];
}

@end
