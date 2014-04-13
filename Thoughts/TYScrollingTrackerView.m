//
//  TYScrollingTrackerView.m
//  Type
//
//  Created by Dom Chapman on 3/28/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYScrollingTrackerView.h"

@interface TYScrollingTrackerView() <UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, strong, readonly) UIView *contentView;

@property (nonatomic, assign, readonly) CGFloat pageWidth;

@end

@implementation TYScrollingTrackerView

@synthesize scrollView = _scrollView,
            contentView = _contentView;


#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


#pragma mark - View Setup

-(void)setupView
{
    [self addSubview:self.scrollView];
    
    [self setupConstraints];
}

-(UIScrollView *)scrollView
{
    if(!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        [self.scrollView addSubview:self.contentView];
    }
    
    return _scrollView;
}

-(UIView *)contentView
{
    if(!_contentView) {
        _contentView = [UIView new];
    }
    
    return _contentView;
}


#pragma mark - Public Properties

-(void)setStickToPages:(BOOL)stickToPages
{
    self.scrollView.pagingEnabled = stickToPages;
}

-(BOOL)stickToPages
{
    return self.scrollView.pagingEnabled;
}


#pragma mark - Private Properties

-(CGFloat)pageOffset
{
    if(self.pageWidth == 0) return 0;
    
    CGFloat pageOffset = self.scrollView.contentOffset.x/self.pageWidth;
    pageOffset = pageOffset-floorf(pageOffset);
    
    if(self.scrollView.contentOffset.x < 0) {
        pageOffset = 1-pageOffset;
    }
    
    return pageOffset;
}

-(CGFloat)pageWidth
{
    return CGRectGetWidth(self.bounds);
}


#pragma mark - ScrollView Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint contentOffset = scrollView.contentOffset;
    
    while(contentOffset.x < 0) {
        contentOffset.x += self.pageWidth;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(scrollingTrackerViewChangedPageLeft:)]) {
            [self.delegate scrollingTrackerViewChangedPageLeft:self];
        }
    }
    
    while (contentOffset.x >= self.pageWidth) {
        contentOffset.x -= self.pageWidth;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(scrollingTrackerViewChangedPageRight:)]) {
            [self.delegate scrollingTrackerViewChangedPageRight:self];
        }
    }
        
    scrollView.contentOffset = contentOffset;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(scrollingTrackerViewPageOffsetChanged:)]) {
        [self.delegate scrollingTrackerViewPageOffsetChanged:self];
    }
}


#pragma mark - Constraints

-(void)setupConstraints
{
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"scrollView": self.scrollView,
                            @"contentView": self.contentView};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:2 constant:0]];

}

@end
