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

@synthesize text = _text, font = _font, characterLabels = _characterLabels;

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
}

-(UIFont *)font
{
    if(!_font) {
        _font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    return _font;
}

-(void)setText:(NSString *)text
{
    
    _text = text;
    
    NSArray *linesOfText = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
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
    
    CGRect frame = self.frame;
    CGSize frameSize = [text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    frame.size = frameSize;
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




@end
