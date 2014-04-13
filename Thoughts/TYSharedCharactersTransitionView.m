//
//  TYSharedCharactersTransitionView.m
//  Type
//
//  Created by Dom Chapman on 3/28/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYSharedCharactersTransitionView.h"
#import "TYMovableCharactersLabel.h"
#import "NSString+MatchedCharacterIndexes.h"
#import "TYUtils.h"
#import "easing.h"


typedef NS_ENUM(NSUInteger, TransitionStage) {
    TransitionStageFadeOut,
    TransitionStageMove,
    TransitionStageFadeIn
};

@interface TYSharedCharactersTransitionView()


//Labels
@property (nonatomic, strong, readonly) TYMovableCharactersLabel *startLabel;

@property (nonatomic, strong, readonly) TYMovableCharactersLabel *endLabel;


//Transition Properties
@property (nonatomic, strong, readwrite) NSArray *fadeOutIndexes;

@property (nonatomic, strong, readwrite) NSArray *fadeInIndexes;

@property (nonatomic, strong, readwrite) NSDictionary *visibleMatchedIndexes;

@property (nonatomic, strong, readwrite) NSDictionary *characterMovePositions;


@end

@implementation TYSharedCharactersTransitionView

@synthesize startLabel = _startLabel,
            endLabel = _endLabel,
            fadeInIndexes = _fadeInIndexes,
            fadeOutIndexes = _fadeOutIndexes,
            visibleMatchedIndexes = _visibleMatchedIndexes,
            characterMovePositions = _characterMovePositions;


#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


#pragma mark - UI

-(void)setupView
{
    [self addSubview:self.startLabel];
    [self addSubview:self.endLabel];
    
    [self setupConstraints];
}

-(TYMovableCharactersLabel *)startLabel
{
    if(!_startLabel) {
        _startLabel = [TYMovableCharactersLabel new];
        _startLabel.textPosition = TYMovableCharactersLabelTextPositionCenter;
    }
    
    return _startLabel;
}

-(TYMovableCharactersLabel *)endLabel
{
    if(!_endLabel) {
        _endLabel = [TYMovableCharactersLabel new];
        _endLabel.textPosition = TYMovableCharactersLabelTextPositionCenter;
    }
    
    return _endLabel;
}


#pragma mark - Public Properties

-(void)setTextPreferredMaxLayoutWidth:(CGFloat)textPreferredMaxLayoutWidth
{
    _textPreferredMaxLayoutWidth = textPreferredMaxLayoutWidth;
    
    self.startLabel.preferredMaxLayoutWidth = self.textPreferredMaxLayoutWidth;
    self.endLabel.preferredMaxLayoutWidth = self.textPreferredMaxLayoutWidth;
    
    [self calculateAndUpdateTransition];
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    [self updateTransition];
}

-(void)setFont:(UIFont *)font
{
    _font = font;
    
    self.startLabel.font = font;
    self.endLabel.font = font;
}

-(NSString *)startText
{
    return self.startLabel.text;
}

-(void)setStartText:(NSString *)startText
{
    self.startLabel.text = startText;
    
    [self calculateAndUpdateTransition];
}

-(NSString *)endText
{
    return self.endLabel.text;
}

-(void)setEndText:(NSString *)endText
{
    self.endLabel.text = endText;
    
    [self calculateAndUpdateTransition];
}

-(void)setTransitionProgress:(CGFloat)transitionProgress
{
    transitionProgress = MAX(transitionProgress, 0);
    transitionProgress = MIN(transitionProgress, 1);
    
    _transitionProgress = transitionProgress;
    
    [self updateTransition];
}


#pragma mark - Private Methods

-(void)calculateAndUpdateTransition
{
    [self calculateTransition];
    [self updateTransition];
}

-(void)resetTransition
{
    //Hide
    self.startLabel.hidden = YES;
    self.endLabel.hidden = YES;
    
    //Reset colors (alpha)
    self.startLabel.textColor = self.textColor;
    self.endLabel.textColor = [UIColor clearColor];
    
    //Reset position offsets
    self.startLabel.positionOffsetsForCharacterIndexes = nil;
}

-(void)updateTransition
{
    //Reset
    [self resetTransition];
    
    
    //Nothing to transition
    if(!self.startText || !self.endText) {
        return;
    }
    
    //Transition at start
    if(self.transitionProgress == 0) {
        self.startLabel.hidden = NO;
        
        return;
    }
    
    //Transition at end
    if(self.transitionProgress == 1) {
        self.endLabel.hidden = NO;
        
        return;
    }
    
    //Mid-Transition
    
    self.startLabel.hidden = NO;
    
    //Move characters
    [self updateMoveTransition];
    
    //Fade out start characters
    [self updateFadeOutTransition];
    
    //Fade in end characters
    if(self.transitionProgress >= 0.5) {
        self.endLabel.hidden = NO;
        [self updateFadeInTransition];
    }
    
}

-(void)updateMoveTransition
{
    //Set the position offsets for the characters in the start text.
    
    CGFloat transitionProgress = self.transitionProgress;
    
    transitionProgress = CubicEaseInOut(transitionProgress);
    
    NSMutableDictionary *positionOffsets = [NSMutableDictionary dictionary];
    
    for (NSNumber *characterIndex in [self.characterMovePositions allKeys]) {
        
        CGPoint movementDelta = [self.characterMovePositions[characterIndex] CGPointValue];
        
        CGPoint positionAtProgress = [TYUtils multiplyPoint:movementDelta by:transitionProgress];
        
        CGPoint characterPoint = [TYUtils roundPoint:positionAtProgress];
        
        positionOffsets[characterIndex] = [NSValue valueWithCGPoint:characterPoint];
    }
    
    self.startLabel.positionOffsetsForCharacterIndexes = [positionOffsets copy];
}

-(void)updateFadeOutTransition
{
    //Fade out the un-matched characters in the start text from 0-0.5 of the transition progress.
    
    CGFloat transitionProgress = self.transitionProgress/0.5; //Normalize for sub-transition
    transitionProgress = MAX(transitionProgress, 0);
    transitionProgress = MIN(transitionProgress, 1);
    
    CGFloat alphaAmount = 1-transitionProgress;
    UIColor *colorAtProgress = [self.textColor colorWithAlphaComponent:alphaAmount];
    
    NSMutableAttributedString *mutableAttributedString = [self.startLabel.attributedText mutableCopy];
    
    for (NSNumber *index in self.fadeOutIndexes) {
        
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:colorAtProgress range:NSMakeRange(index.unsignedIntegerValue, 1)];
    }
    
    self.startLabel.attributedText = [mutableAttributedString copy];
}

-(void)updateFadeInTransition
{
    //Fade in the un-matched characters in the end text from 0.5-1 of the transition progress.
    
    CGFloat transitionProgress = (self.transitionProgress-0.5)/0.5; //Normalize for sub-transition
    transitionProgress = MAX(transitionProgress, 0);
    transitionProgress = MIN(transitionProgress, 1);
    
    CGFloat alphaAmount = transitionProgress;
    UIColor *colorAtProgress = [self.textColor colorWithAlphaComponent:alphaAmount];
    
    NSMutableAttributedString *mutableAttributedString = [self.endLabel.attributedText mutableCopy];
    
    for (NSNumber *index in self.fadeInIndexes) {
        
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:colorAtProgress range:NSMakeRange(index.unsignedIntegerValue, 1)];
    }
    
    self.endLabel.attributedText = [mutableAttributedString copy];
}

-(void)calculateTransition
{
    [self calculateVisibleMatchedIndexesAndCharacterMovePositions];
    [self calculateFadingIndexes];
}

-(void)calculateFadingIndexes
{
    NSArray *matchedStartIndexes = [self.visibleMatchedIndexes allKeys];
    NSArray *matchedEndIndexes = [self.visibleMatchedIndexes allValues];
    
    self.fadeOutIndexes = [self arrayOfSequentialNumbersWithCount:[self.startText length] excludeNumbersFromArray:matchedStartIndexes];
    self.fadeInIndexes = [self arrayOfSequentialNumbersWithCount:[self.endText length] excludeNumbersFromArray:matchedEndIndexes];
}

-(void)calculateVisibleMatchedIndexesAndCharacterMovePositions
{
    NSMutableDictionary *characterMovePositions = [NSMutableDictionary dictionary];
    NSMutableDictionary *visibleMatchedIndexes = [NSMutableDictionary dictionary];
    
    NSDictionary *startCharacterPositions = [self.startLabel calculateVisibleCharacterPositions];
    NSDictionary *endCharacterPositions = [self.endLabel calculateVisibleCharacterPositions];
    
    NSDictionary *matchedIndexes = [self.startText indexesOfMatchedCharactersWithString:self.endText dispersedMatching:YES];
    
    for (NSNumber *startCharacterIndexNumber in [matchedIndexes keyEnumerator]) {
        
        NSNumber *endCharacterIndexNumber = matchedIndexes[startCharacterIndexNumber];
        
        NSValue *startPositionValue = startCharacterPositions[startCharacterIndexNumber];
        NSValue *endPositionValue = endCharacterPositions[endCharacterIndexNumber];
        
        //Matched characters might not be drawn (depending on word-wrapping/label size .etc)
        if(startPositionValue && endPositionValue) {
            
            visibleMatchedIndexes[startCharacterIndexNumber] = endCharacterIndexNumber;
            
            CGPoint startPosition = [startPositionValue CGPointValue];
            CGPoint endPosition = [endPositionValue CGPointValue];
            
            CGPoint delta = [TYUtils subtractPoint:startPosition fromPoint:endPosition];
            
            characterMovePositions[startCharacterIndexNumber] = [NSValue valueWithCGPoint:delta];
        }
    }
    
    self.visibleMatchedIndexes = [visibleMatchedIndexes copy];
    self.characterMovePositions = [characterMovePositions copy];
}


#pragma mark - Private Helpers

-(NSArray *)arrayOfSequentialNumbersWithCount:(NSUInteger)count excludeNumbersFromArray:(NSArray *)excludeArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSUInteger i=0; i<count; i++) {
        
        NSNumber *iNumber = @(i);
        
        if(![excludeArray containsObject:iNumber]) {
            [array addObject:iNumber];
        }
        
    }
    
    return [array copy];
}


#pragma mark - Constraints

-(void)setupConstraints
{
    self.startLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.endLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *views = @{@"startLabel": self.startLabel,
                            @"endLabel": self.endLabel};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[startLabel]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[startLabel]|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[endLabel]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[endLabel]|" options:0 metrics:nil views:views]];
    
}

@end
