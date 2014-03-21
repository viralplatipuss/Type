//
//  NSString+WordWrappedLineBreaks.h
//  Type
//
//  Created by Dom Chapman on 3/19/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WordWrappedLineBreaks)

/*
 Returns: A string from the given attributed string with line breaks immitating word wrapping for the set width.
 */
+(NSString *)stringWithAttributedString:(NSAttributedString *)attributedString withLineBreakWordWrappingForWidth:(CGFloat)width stripWhitespaceAtBeginningAndEndOflines:(BOOL)stripWhitespace;

@end
