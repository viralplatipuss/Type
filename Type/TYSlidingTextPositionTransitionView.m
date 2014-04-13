//
//  TYSlidingTextPositionView.m
//  Type
//
//  Created by Dom Chapman on 4/6/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYSlidingTextPositionTransitionView.h"
#import "TYMovableCharactersLabel.h"

@interface TYSlidingTextPositionTransitionView()

@property (nonatomic, strong, readonly) TYMovableCharactersLabel *charactersLabel;

@end

@implementation TYSlidingTextPositionTransitionView

@synthesize charactersLabel = _charactersLabel;


#pragma mark - Init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
        //Default
        self.endPosition = TYMovableCharactersLabelTextPositionCenter;
        
    }
    return self;
}


#pragma mark - View Setup

-(void)setupView
{
    [self addSubview:self.charactersLabel];
    
    [self setupConstraints];
}

-(TYMovableCharactersLabel *)charactersLabel
{
    if(!_charactersLabel) {
        _charactersLabel = [TYMovableCharactersLabel new];
    }
    
    return _charactersLabel;
}


#pragma mark - Public Properties

-(void)setTransitionProgress:(CGFloat)transitionProgress
{
    transitionProgress = MAX(transitionProgress, 0);
    transitionProgress = MIN(transitionProgress, 1);
    
    _transitionProgress = transitionProgress;
    
    [self updateTransition];
}

-(UIFont *)font
{
    return self.charactersLabel.font;
}

-(void)setFont:(UIFont *)font
{
    self.charactersLabel.font = font;
}

-(UIColor *)textColor
{
    return self.charactersLabel.textColor;
}

-(void)setTextColor:(UIColor *)textColor
{
    self.charactersLabel.textColor = textColor;
}

-(NSString *)text
{
    return self.charactersLabel.text;
}

-(void)setText:(NSString *)text
{
    self.charactersLabel.text = text;
}

-(CGFloat)preferredMaxLayoutWidth
{
    return self.charactersLabel.preferredMaxLayoutWidth;
}

-(void)setPreferredMaxLayoutWidth:(CGFloat)textPreferredMaxLayoutWidth
{
    self.charactersLabel.preferredMaxLayoutWidth = textPreferredMaxLayoutWidth;
}


#pragma mark - Private Methods

-(void)updateTransition
{
    CGFloat startX = self.startTextInsetX;
    CGFloat endX = self.endTextInsetX;
    
    if(self.startPosition == TYSlidingTextPositionTransitionViewTextPositionCenter) {
        startX += [self xOffsetForCenteredText];
    }
    
    if(self.endPosition == TYSlidingTextPositionTransitionViewTextPositionCenter) {
        endX += [self xOffsetForCenteredText];
    }
    
    
    CGFloat movementDistance = endX-startX;
    
    NSMutableDictionary *positionOffsets = [NSMutableDictionary dictionary];
    
    for (NSUInteger index=0; index<self.text.length; index++) {
        
        CGFloat easedProgress = ElasticEaseOutWithIndex(self.transitionProgress,index);
        
        CGPoint offset = CGPointMake(roundf((movementDistance*easedProgress)+startX), 0);
        positionOffsets[@(index)] = [NSValue valueWithCGPoint:offset];
    }
    
    self.charactersLabel.positionOffsetsForCharacterIndexes = [positionOffsets copy];
}

//Custom easing
CGFloat ElasticEaseOutWithIndex(CGFloat p, CGFloat i)
{
	return sin(-(13+(i*0.1*p)) * M_PI_2 * (p + 1)) * pow(2, -10 * p) + 1;
}

-(CGFloat)xOffsetForCenteredText
{
    CGFloat textWidth = self.charactersLabel.intrinsicContentSize.width;
    return (CGRectGetWidth(self.bounds)-textWidth)*0.5f;
}


#pragma mark - Constraints

-(void)setupConstraints
{
    self.charactersLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"charactersLabel":self.charactersLabel};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[charactersLabel]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[charactersLabel]|" options:0 metrics:nil views:views]];
}

@end
