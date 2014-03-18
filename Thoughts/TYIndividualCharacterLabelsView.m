//
//  THTextEntryView.m
//  Thoughts
//
//  Created by Dom Chapman on 3/15/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYIndividualCharacterLabelsView.h"

@interface TYIndividualCharacterLabelsView()

@property (nonatomic, strong, readwrite) NSArray *characterLabels;

@end

@implementation TYIndividualCharacterLabelsView

@synthesize text = _text, font = _font, characterLabels = _characterLabels, textColor = _textColor;

-(instancetype)init
{
    return self = [super init];
}

-(UIColor *)textColor
{
    if(!_textColor) {
        _textColor = [UIColor blackColor];
    }
    
    return _textColor;
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    for (UILabel *label in self.characterLabels) {
        
        if(label != (UILabel *)[NSNull null]) { //eww, find a better solution to NSNull stuff.
            label.textColor = self.textColor;
        }
    }

}

-(UIFont *)font
{
    if(!_font) {
        _font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    return _font;
}

-(void)setFont:(UIFont *)font
{
    _font = font;
    
    [self redrawText];
}

-(void)setText:(NSString *)text
{
    _text = text;
    
    [self redrawText];
}

-(void)wipeText
{
    for (UILabel *label in self.characterLabels) {
        
        if(label != (UILabel *)[NSNull null]) { //eww, find a better solution to NSNull stuff.
            [label removeFromSuperview];
        }
    }
    
    self.characterLabels = nil;
}

-(void)redrawText
{
    [self wipeText];
    
    NSArray *linesOfText = [self.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    CGFloat lineOffsetY = 0;
    
    CGFloat lineHeight = [@"" sizeWithAttributes:@{NSFontAttributeName:self.font}].height;
    
    NSMutableArray *newCharacterLabels = [NSMutableArray array];
    
    for (NSUInteger lineNumber=0; lineNumber<linesOfText.count; lineNumber++) {
        
        
        if(lineNumber > 0) {
            //Character for the new line added at correct index.
            [newCharacterLabels addObject:[NSNull null]];
        }
        
        
        NSString *lineOfText = linesOfText[lineNumber];
        
        for (NSUInteger characterNumber=0; characterNumber<lineOfText.length; characterNumber++) {
            
            UILabel *characterLabel = [UILabel new];
            characterLabel.font = self.font;
            characterLabel.text = [lineOfText substringWithRange:NSMakeRange(characterNumber, 1)];
            characterLabel.textColor = self.textColor;
            [characterLabel sizeToFit];
            
            NSString *lineOfTextUpToCharacter = [lineOfText substringToIndex:characterNumber];
            CGSize sizeOfLineOfTextUpToCharacter = [lineOfTextUpToCharacter sizeWithAttributes:@{NSFontAttributeName:self.font}];
            
            characterLabel.frame = CGRectIntegral(CGRectOffset(characterLabel.frame, sizeOfLineOfTextUpToCharacter.width, lineOffsetY));
            
            [self addSubview:characterLabel];
            
            [newCharacterLabels addObject:characterLabel];
            
        }
        
        lineOffsetY += lineHeight;
        
    }
    
    self.characterLabels = newCharacterLabels;
    
    
    
    if(self.translatesAutoresizingMaskIntoConstraints == YES) {
        //If not using autolayout, manually resize frame.
        [self updateFrameToMatchContentSize];
    }
    [self invalidateIntrinsicContentSize];
    
}

-(CGSize)intrinsicContentSize
{
    CGSize contentSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    return CGSizeMake(ceilf(contentSize.width), ceilf(contentSize.height));
}

-(void)updateFrameToMatchContentSize
{
    CGRect frame = self.frame;
    frame.size = [self intrinsicContentSize];
    self.frame = CGRectIntegral(frame);
}

-(UILabel *)labelForCharacterAtIndex:(NSUInteger)index
{
    if(index >= self.characterLabels.count) return nil;
    
    if(self.characterLabels[index] == [NSNull null]) {
        return nil;
    }
    
    return self.characterLabels[index];
}

-(NSArray *)characterLabels
{
    if(!_characterLabels) {
        _characterLabels = @[];
    }
    
    return _characterLabels;
}

-(NSString *)text
{
    if(!_text) {
        _text = @"";
    }
    
    return _text;
}




@end
