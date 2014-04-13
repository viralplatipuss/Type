//
//  TYMovableCharactersLayer.m
//  Type
//
//  Created by Dom Chapman on 3/26/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYMovableCharactersLayer.h"
#import <CoreText/CoreText.h>
#import "TYUtils.h"

@implementation TYMovableCharactersLayer


-(BOOL)needsDisplayOnBoundsChange
{
    return YES;
}


#pragma mark - Private Methods

-(NSAttributedString *)attributedString
{
    if(!self.dataSource) {
        return nil;
    }
    
    NSAttributedString *attributedString = [self.dataSource attributedStringForMovableCharactersLayer:self];
    NSAttributedString *drawingAttributedString = [self attributedStringWithLigaturesDisabled:attributedString];
    
    return drawingAttributedString;
}

-(CGRect)textFrame
{
    CGRect textFrame = CGRectZero;
    
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(textFrameForMovableCharactersLayer:)]) {
        textFrame = [self.dataSource textFrameForMovableCharactersLayer:self];
    }
    
    if(CGRectIsEmpty(textFrame)) {
        textFrame = self.bounds;
    }
    
    //Flip textFrame's y to match quartz co-ord system
    textFrame.origin.y = CGRectGetHeight(self.bounds)-CGRectGetHeight(textFrame);
    
    //Calculate minimum height to fit string
    CGFloat minimumHeight = [self sizeThatFitsAttributedString:[self attributedString] constrainedToSize:textFrame.size].height;

    
    //Vertically center the textFrame's text within itself
    textFrame.origin.y += (CGRectGetHeight(textFrame)-minimumHeight)*0.5f;
    textFrame.size.height = minimumHeight;
    
    //Ceil frame for whole-number drawing values
    textFrame = CGRectIntegral(textFrame);
    
    
    return textFrame;
}

-(CGSize)sizeThatFitsAttributedString:(NSAttributedString *)attributedString constrainedToSize:(CGSize)constraintSize
{
    if(!attributedString) {
        return CGSizeZero;
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)[self attributedString]);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, constraintSize, NULL);
    CFRelease(framesetter);
    
    size = [TYUtils ceilSize:size];
    
    return size;
}


#pragma mark - Public Methods

//----Messy Method - clean this up later-----

/* Assumes 1:1 glyphs:characters, which should be true with ligatures disabled */
-(NSDictionary *)calculateVisibleCharacterPositions
{
    NSMutableDictionary *characterPositions = [NSMutableDictionary dictionary];
    
    
    NSAttributedString *attributedString = [self attributedString];
    if(!attributedString) {
        return nil;
    }
    
    CGRect textFrame = [self textFrame];
    
    
    CTFrameRef frame = [self newFrameWithAttributedString:attributedString size:textFrame.size];

    CGPoint framePoint = textFrame.origin;
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    CGPoint *lineOffsets = calloc(lines.count, sizeof(CGPoint));
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOffsets);
    
    
    for (NSUInteger lineIndex=0; lineIndex<lines.count; lineIndex++) {
        
        CTLineRef line = (__bridge CTLineRef)lines[lineIndex];
        
        CGPoint linePoint = [TYUtils addPoint:lineOffsets[lineIndex] toPoint:framePoint];
        
        NSArray *runs = (__bridge NSArray *)CTLineGetGlyphRuns(line);
        
        for (id run in runs) {
            
            CFIndex glyphCount = CTRunGetGlyphCount((__bridge CTRunRef)run);
            
            CGPoint *positions = calloc(glyphCount, sizeof(CGPoint));
            CTRunGetPositions((__bridge CTRunRef)run, CFRangeMake(0, 0), positions);
            
            for (NSUInteger glyphIndex=0; glyphIndex<glyphCount; glyphIndex++) {
                
                CGPoint characterPosition = positions[glyphIndex];
                characterPosition = [TYUtils addPoint:characterPosition toPoint:linePoint];
                
                CFIndex stringIndex;
                
                CTRunGetStringIndices((__bridge CTRunRef)run, CFRangeMake(glyphIndex, 1), &stringIndex);
                
                CGRect glyphBounds = CTRunGetImageBounds((__bridge CTRunRef)run, nil, CFRangeMake(glyphIndex, 1));
                
                characterPosition.y = CGRectGetHeight(self.bounds)-(characterPosition.y+CGRectGetHeight(glyphBounds));
                
                characterPosition = CGPointMake(roundf(characterPosition.x), roundf(characterPosition.y));
                
                characterPositions[@(stringIndex)] = [NSValue valueWithCGPoint:characterPosition];
            }
        }
    }
    
    
    CFRelease(frame);
    
    return [characterPositions copy];
}

-(void)drawInContext:(CGContextRef)ctx
{
    NSAttributedString *attributedString = [self attributedString];
    if(!attributedString) {
        return;
    }
    
    CGRect textFrame = [self textFrame];
    
    //Get and flip context
    CGContextTranslateCTM(ctx, 0, CGRectGetHeight(self.bounds));
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    
    
    //Draw
    [self drawAttributedString:attributedString inRect:textFrame withPositionOffsetsForCharacterIndexes:[self.dataSource positionOffsetsForCharacterIndexesForMovableCharactersLayer:self] context:ctx];
}


#pragma mark - Drawing Methods

/*
 Draws an attributed string in the context, while offsetting the position of any characters referenced in the positionOffsets dictionary, by the CGPoint given for the character's string index.
 */
-(void)drawAttributedString:(NSAttributedString *)attributedString inRect:(CGRect)rect withPositionOffsetsForCharacterIndexes:(NSDictionary*)positionOffsets context:(CGContextRef)context
{
    CTFrameRef frame = [self newFrameWithAttributedString:attributedString size:rect.size];
    
    [self drawFrame:frame atPoint:rect.origin inContext:context withPositionOffsetsForCharacterIndexes:positionOffsets];
    
    CFRelease(frame);
}


-(void)drawFrame:(CTFrameRef)frame atPoint:(CGPoint)point inContext:(CGContextRef)context withPositionOffsetsForCharacterIndexes:(NSDictionary*)positionOffsets
{
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);

    CGPoint *lineOffsets = calloc(lines.count, sizeof(CGPoint));
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOffsets);
    
    for (NSUInteger lineIndex=0; lineIndex<lines.count; lineIndex++) {
        
        CTLineRef line = (__bridge CTLineRef)lines[lineIndex];
       
        CGPoint linePoint = [TYUtils addPoint:lineOffsets[lineIndex] toPoint:point];
        
        [self drawLine:line atPoint:linePoint inContext:context withPositionOffsetsForCharacterIndexes:positionOffsets];
    }
}

-(void)drawLine:(CTLineRef)line atPoint:(CGPoint)point inContext:(CGContextRef)context withPositionOffsetsForCharacterIndexes:(NSDictionary*)positionOffsets
{
    NSArray *runs = (__bridge NSArray *)CTLineGetGlyphRuns(line);
    
    for (id run in runs) {
        [self drawRun:(__bridge CTRunRef)run atPoint:point inContext:context withPositionOffsetsForCharacterIndexes:positionOffsets];
    }
}

-(void)drawRun:(CTRunRef)run atPoint:(CGPoint)point inContext:(CGContextRef)context withPositionOffsetsForCharacterIndexes:(NSDictionary*)positionOffsets
{
    CFIndex glyphCount = CTRunGetGlyphCount(run);

    CGGlyph *glyphs = calloc(glyphCount, sizeof(CGGlyph));
    CTRunGetGlyphs(run, CFRangeMake(0, 0), glyphs);
    
    CGPoint *positions = [self positionsInRun:run withPositionOffsetsForCharacterIndexes:positionOffsets];
    
    [self setContext:context fontAndColorFromRun:run];
    
    CGContextSetTextPosition(context, point.x, point.y);
    
    CGContextShowGlyphsAtPositions(context, glyphs, positions, glyphCount);
}


#pragma mark - Helpers

-(NSAttributedString *)attributedStringWithLigaturesDisabled:(NSAttributedString *)attributedString
{
    if(!attributedString) return nil;
    
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    
    [mutableAttributedString addAttribute:NSLigatureAttributeName value:@0 range:NSMakeRange(0, mutableAttributedString.length)];
    
    return [mutableAttributedString copy];
}

/*
 WARNING:   I'm making the assumption, due to ligatures being disabled, that there is a 1-to-1 ratio of characters to glyphs.
            This may need to be changed later if bugs are found.
 
 */
-(CGPoint *)positionsInRun:(CTRunRef)run withPositionOffsetsForCharacterIndexes:(NSDictionary *)positionOffsets
{
    CFIndex glyphCount = CTRunGetGlyphCount(run);
    
    CGPoint *positions = calloc(glyphCount, sizeof(CGPoint));
    CTRunGetPositions(run, CFRangeMake(0, 0), positions);
    
    
    //Determine the character indexes in this run
    CFIndex firstStringIndex;
    CTRunGetStringIndices(run, CFRangeMake(0, 1), &firstStringIndex);
    NSUInteger lastStringIndex = firstStringIndex+glyphCount-1;
    
    
    //Iterate the string indexes in this run, checking for position offsets
    NSUInteger positionIndex = 0;
    for (NSUInteger stringIndex=firstStringIndex; stringIndex<=lastStringIndex; stringIndex++) {
        
        NSValue *pointValue = positionOffsets[@(stringIndex)];
        if(pointValue) {
            //Add the offset to the position
            CGPoint offset = pointValue.CGPointValue;
            positions[positionIndex].x += offset.x;
            positions[positionIndex].y -= offset.y; //- for inverted co-ord system
        }
        positionIndex ++;
    }
    
    
    return positions;
}

-(void)setContext:(CGContextRef)context fontAndColorFromRun:(CTRunRef)run
{
    NSDictionary *attributes = (__bridge id)CTRunGetAttributes(run);
    
    CTFontRef font = (__bridge CTFontRef)attributes[NSFontAttributeName];
    CGFontRef cgFont = CTFontCopyGraphicsFont(font, NULL);
    
    
    CGContextSetFont(context, cgFont);
    CGContextSetFontSize(context, CTFontGetSize(font));
    
    CFRelease(cgFont);
    
    UIColor *color = attributes[NSForegroundColorAttributeName];
    
    CGContextSetFillColorWithColor(context, color.CGColor);
}

-(CTFrameRef)newFrameWithAttributedString:(NSAttributedString *)attributedString size:(CGSize)size
{
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
	
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    CFRelease(path);
    CFRelease(framesetter);
    
    return frame;
}

@end
