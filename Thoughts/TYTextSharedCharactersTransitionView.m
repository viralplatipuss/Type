//
//  TYTextSharedCharactersTransitionView.m
//  Type
//
//  Created by Dom Chapman on 3/20/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYTextSharedCharactersTransitionView.h"
#import "TYIndividualCharacterLabelsView.h"
#import "MTRandom.h"


static NSString * const kDictionaryKeyForCharacter = @"character";

static NSString * const kDictionaryKeyForCharacterIndex = @"index";


@interface TYTextSharedCharactersTransitionView()

@property (nonatomic, strong, readonly) TYIndividualCharacterLabelsView *charactersView;

@end

@implementation TYTextSharedCharactersTransitionView

@synthesize charactersView = _charactersView, startText = _startText, endText = _endText, transitionAmount = _transitionAmount;

#pragma mark - Init

-(instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if(self) {
        [self setupView];
    }
    
    return self;
}


#pragma mark - UI

-(void)setupView
{
    [self addSubview:self.charactersView];
}

-(TYIndividualCharacterLabelsView *)charactersView
{
    if(!_charactersView) {
        _charactersView = [TYIndividualCharacterLabelsView new];
    }
    
    return _charactersView;
}


#pragma mark - Public Properties

-(void)setStartText:(NSString *)startText
{
    _startText = startText;
}

-(void)setTransitionAmount:(CGFloat)transitionAmount
{
    _transitionAmount = transitionAmount;
}

-(CGSize)intrinsicContentSize
{
    return self.charactersView.intrinsicContentSize;
}


#pragma mark - Private Methods

-(void)um
{
    
    
}

-(NSMutableArray *)mutableArrayOfDictionariesOfCharactersAndIndexesInString:(NSString *)string
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSUInteger i=0; i<string.length; i++) {
        
        NSDictionary *dictionary = @{kDictionaryKeyForCharacter: [string substringWithRange:NSMakeRange(i, 1)],
                                     kDictionaryKeyForCharacterIndex: @(i)};
        
        [array addObject:dictionary];
    }

    return array;
}

-(void)updateTransition
{
    
    if(self.transitionAmount < 0.6) {
        self.charactersView.text = self.startText;
    }else {
        self.charactersView.text = self.endText;
    }
    
}

@end
