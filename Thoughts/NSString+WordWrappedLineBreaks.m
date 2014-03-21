//
//  NSString+WordWrappedLineBreaks.m
//  Type
//
//  Created by Dom Chapman on 3/19/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "NSString+WordWrappedLineBreaks.h"

@implementation NSString (WordWrappedLineBreaks)


+(NSString *)stringWithAttributedString:(NSAttributedString *)attributedString withLineBreakWordWrappingForWidth:(CGFloat)width stripWhitespaceAtBeginningAndEndOflines:(BOOL)stripWhitespace
{
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(width, CGFLOAT_MAX)];
    textContainer.lineFragmentPadding = 0;
    
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedString];
    
    [textStorage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:textContainer];
    
    __block NSString *wordWrappedString = @"";

    
    [layoutManager enumerateLineFragmentsForGlyphRange:NSMakeRange(0, layoutManager.numberOfGlyphs) usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer *textContainer, NSRange glyphRange, BOOL *stop) {
        
        if(wordWrappedString.length) {
            wordWrappedString = [wordWrappedString stringByAppendingString:@"\n"];
        }
        
        NSRange characterRangeForLine = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:nil];
        
        NSString *textForLine = [attributedString.string substringWithRange:characterRangeForLine];
        
        if(stripWhitespace) {
            textForLine = [textForLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        wordWrappedString = [wordWrappedString stringByAppendingString:textForLine];
        
    }];
    
    return wordWrappedString;
}

@end
