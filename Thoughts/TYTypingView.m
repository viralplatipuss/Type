//
//  TYTypingView.m
//  Type
//
//  Created by Dom Chapman on 3/17/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYTypingView.h"
#import "TYIndividualCharacterLabelsView.h"
#import "UIColor+HexString.h"


static const NSUInteger kCharacterLimit = 60;


@interface TYTypingView() <UIKeyInput, UITextInputTraits>

@property (nonatomic, strong, readonly) TYIndividualCharacterLabelsView *labelsView;

@property (nonatomic, copy, readonly) NSString *wordWrappedText;

//TEMP
@property (nonatomic, strong, readonly) UILabel *label;

@end

@implementation TYTypingView

@synthesize labelsView = _labelsView, label = _label, text = _text;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
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
    //self.backgroundColor = [UIColor greenColor];
    [self addSubview:self.labelsView];
    
    [self setupConstraints];
}

-(UILabel *)label
{
    if(!_label) {
        _label = [UILabel new];
    }
    
    return _label;
}

-(TYIndividualCharacterLabelsView *)labelsView
{
    if(!_labelsView) {
        _labelsView = [TYIndividualCharacterLabelsView new];
        _labelsView.textColor = [UIColor colorWithHexString:@"002fb5"];
    }
    
    return _labelsView;
}

#pragma mark - Public Properties

-(UIFont *)font
{
    return self.labelsView.font;
}

-(void)setFont:(UIFont *)font
{
    self.labelsView.font = font;
}

#pragma mark - Private Properties

-(void)setText:(NSString *)text
{
    //Strip carriage returns
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //Limit character count.
    if(text.length > kCharacterLimit) {
        text = [text substringToIndex:kCharacterLimit];
    }
    
    _text = text;
    
    self.labelsView.text = self.wordWrappedText;
}

-(NSString *)text
{
    if(!_text) {
        _text = @"";
    }
    
    return _text;
}

-(NSString *)wordWrappedText
{
    return [self newLineWordWrapString:self.text withFont:self.font forWidth:CGRectGetWidth(self.frame)];
}


#pragma mark - Key Input Methods

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)hasText
{
    return YES;
}

-(void)insertText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [self resignFirstResponder];
        return;
    }
    
    self.text = [self.text stringByAppendingString:text];
}

-(void)deleteBackward
{
    self.text = [self.text substringToIndex:self.text.length-1];
    
    if(self.text.length == 0) {
        [self resignFirstResponder];
    }
}


#pragma mark - UITextInputTraits Properties

-(UIKeyboardAppearance)keyboardAppearance
{
    return UIKeyboardAppearanceDark;
}

-(UIReturnKeyType)returnKeyType
{
    return UIReturnKeyDone;
}

-(UIKeyboardType)keyboardType
{
    return UIKeyboardTypeAlphabet;
}

-(UITextAutocapitalizationType)autocapitalizationType
{
    return UITextAutocapitalizationTypeSentences;
}


#pragma mark - Private Helpers

/*
 Returns: A string word-wrapped for the set width and font with each word-wrapped new line as a hardcoded new line character.
 */
-(NSString *)newLineWordWrapString:(NSString *)string withFont:(UIFont *)font forWidth:(CGFloat)width
{
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(width, CGFLOAT_MAX)];
    
    textContainer.lineFragmentPadding = 0;
    
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    //string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:string attributes:@{NSFontAttributeName:font}];
    
    [textStorage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:textContainer];
    
    __block NSString *wordWrappedString = @"";
    
    [layoutManager enumerateLineFragmentsForGlyphRange:NSMakeRange(0, layoutManager.numberOfGlyphs) usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer *textContainer, NSRange glyphRange, BOOL *stop) {
        
        if(wordWrappedString.length) {
            wordWrappedString = [wordWrappedString stringByAppendingString:@"\n"];
        }
        
        NSRange characterRangeForLine = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:nil];
        
        wordWrappedString = [wordWrappedString stringByAppendingString:[string substringWithRange:characterRangeForLine]];
        
    }];
    
    return wordWrappedString;
}


#pragma mark - Constraints

-(void)setupConstraints
{
    
    self.labelsView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelsView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelsView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}


@end
