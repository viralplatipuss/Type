//
//  THMovableCharactersLabel.m
//  Type
//
//  Created by Dom Chapman on 3/26/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYMovableCharactersLabel.h"
#import "TYMovableCharactersLayer.h"
#import "TYUtils.h"

@interface TYMovableCharactersLabel() <TYMovableCharactersLayerDataSource>


@property (nonatomic, strong, readonly) TYMovableCharactersLayer *movableCharactersLayer;


@property (nonatomic, strong, readwrite) UIFont *underlyingFont;

@property (nonatomic, strong, readwrite) UIColor *underlyingTextColor;

@property (nonatomic, assign, readwrite) NSTextAlignment underlyingTextAlignment;

@property (nonatomic, assign, readwrite) NSLineBreakMode underlyingLineBreakMode;


@end

@implementation TYMovableCharactersLabel

@synthesize underlyingFont = _underlyingFont,
            underlyingTextColor = _underlyingTextColor,
            underlyingTextAlignment = _underlyingTextAlignment,
            underlyingLineBreakMode = _underlyingLineBreakMode;


#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //Defaults
        self.backgroundColor = [UIColor clearColor];
        _underlyingTextAlignment = NSTextAlignmentNatural;
        _underlyingLineBreakMode = NSLineBreakByWordWrapping;
        
        //Correct text antialiasing
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        
        //Set layer's datasource to self
        self.movableCharactersLayer.dataSource = self;
        
    }
    return self;
}


#pragma mark - Public Methods

-(NSDictionary *)calculateVisibleCharacterPositions
{
    return [self.movableCharactersLayer calculateVisibleCharacterPositions];
}


#pragma mark - Layout Methods

-(void)sizeToFit
{
    CGRect frame = self.frame;
    frame.size = [self intrinsicContentSize];
    self.frame = frame;
}

-(CGSize)intrinsicContentSize
{
    CGSize size = [self.movableCharactersLayer sizeThatFitsAttributedString:self.attributedText constrainedToSize:CGSizeMake(self.preferredMaxLayoutWidth, 0)];
    
    size = [TYUtils ceilSize:size];
    
    return size;
}

-(void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth
{
    _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    [self invalidateIntrinsicContentSize];
}

-(void)setTextPosition:(TYMovableCharactersLabelTextPosition)textPosition
{
    _textPosition = textPosition;
    [self.layer setNeedsDisplay];
}

-(void)setTextInset:(CGPoint)textInset
{
    _textInset = textInset;
    [self.layer setNeedsDisplay];
}


#pragma mark - Layer DataSource Methods

-(NSAttributedString *)attributedStringForMovableCharactersLayer:(TYMovableCharactersLayer *)movableCharactersLayer
{
    return self.attributedText;
}

-(NSDictionary *)positionOffsetsForCharacterIndexesForMovableCharactersLayer:(TYMovableCharactersLayer *)movableCharactersLayer
{
    return self.positionOffsetsForCharacterIndexes;
}

-(CGRect)textFrameForMovableCharactersLayer:(TYMovableCharactersLayer *)movableCharactersLayer
{
    CGRect textFrame = CGRectZero;
    
    switch (self.textPosition) {
        case TYMovableCharactersLabelTextPositionCenter:
            textFrame = [self textFrameForCenteredText];
            break;
            
        default:
            textFrame = [self textFrameForLeftText];
            break;
    }
    
    textFrame = CGRectOffset(textFrame, self.textInset.x, self.textInset.y);
    
    return textFrame;
}


#pragma mark - Text Properties

-(void)setPositionOffsetsForCharacterIndexes:(NSDictionary *)positionOffsetsForCharacterIndexes
{
    _positionOffsetsForCharacterIndexes = positionOffsetsForCharacterIndexes;
    [self.layer setNeedsDisplay];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    if(attributedText && attributedText.length) {
    
        NSMutableAttributedString *mutableAttributedText = [attributedText mutableCopy];
        NSRange fullTextRange = NSMakeRange(0, mutableAttributedText.length);
        
        //Make sure ligatures are disabled
        [mutableAttributedText addAttribute:NSLigatureAttributeName value:@0 range:fullTextRange];
        
        //Scan for missing attributes and add if needed.
        UIFont *font = [mutableAttributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
        if(!font) {
            [mutableAttributedText addAttribute:NSFontAttributeName value:self.underlyingFont range:fullTextRange];
        }
        
        UIColor *color = [mutableAttributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
        if(!color) {
            [mutableAttributedText addAttribute:NSForegroundColorAttributeName value:self.underlyingTextColor range:fullTextRange];
        }
        
        NSParagraphStyle *paragraphStyle = [mutableAttributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
        if(!paragraphStyle) {
            NSMutableParagraphStyle *mutableParagraphStyle = [NSMutableParagraphStyle new];
            mutableParagraphStyle.alignment = self.underlyingTextAlignment;
            mutableParagraphStyle.lineBreakMode = self.underlyingLineBreakMode;
            [mutableAttributedText addAttribute:NSParagraphStyleAttributeName value:[mutableParagraphStyle copy] range:fullTextRange];
        }
        
        attributedText = [mutableAttributedText copy];
    }
    
    _attributedText = attributedText;
    
    [self invalidateIntrinsicContentSize];
    [self.layer setNeedsDisplay];
}

-(NSString *)text
{
    if(!self.attributedText) {
        return nil;
    }
    
    return self.attributedText.string;
}

-(void)setText:(NSString *)text
{
    if(!text) {
        self.attributedText = nil;
        return;
    }
    
    self.attributedText = [[NSAttributedString alloc] initWithString:text];
}

-(UIFont *)font
{
    if(self.attributedText && self.attributedText.length) {
        UIFont *font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
        if(font) {
            return font;
        }
    }
    
    return self.underlyingFont;
}

-(void)setFont:(UIFont *)font
{
    self.underlyingFont = font;
}

-(UIColor *)textColor
{
    if(self.attributedText && self.attributedText.length) {
        UIColor *textColor = [self.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
        if(textColor) {
            return textColor;
        }
    }
    
    return self.underlyingTextColor;
}

-(void)setTextColor:(UIColor *)textColor
{
    self.underlyingTextColor = textColor;
}

-(NSTextAlignment)textAlignment
{
    if(self.attributedText && self.attributedText.length) {
        NSParagraphStyle *paragraphStyle = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
        if(paragraphStyle) {
            return paragraphStyle.alignment;
        }
    }
    
    return self.underlyingTextAlignment;
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.underlyingTextAlignment = textAlignment;
}

-(NSLineBreakMode)lineBreakMode
{
    if(self.attributedText && self.attributedText.length) {
        NSParagraphStyle *paragraphStyle = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
        if(paragraphStyle) {
            return paragraphStyle.lineBreakMode;
        }
    }
    
    return self.underlyingLineBreakMode;
}

-(void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    self.underlyingLineBreakMode = lineBreakMode;
}


#pragma mark - Private Text Properties

-(UIColor *)underlyingTextColor
{
    if(!_underlyingTextColor) {
        _underlyingTextColor = [UIColor blackColor];
    }
    
    return _underlyingTextColor;
}

-(void)setUnderlyingTextColor:(UIColor *)underlyingTextColor
{
    _underlyingTextColor = underlyingTextColor;
    
    if(self.attributedText) {
        self.attributedText = [self attributedString:self.attributedText withAdddedAttribute:NSForegroundColorAttributeName value:self.underlyingTextColor];
    }
}

-(UIFont *)underlyingFont
{
    if(!_underlyingFont) {
        _underlyingFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    return _underlyingFont;
}

-(void)setUnderlyingFont:(UIFont *)underlyingFont
{
    _underlyingFont = underlyingFont;
    
    if(self.attributedText) {
        self.attributedText = [self attributedString:self.attributedText withAdddedAttribute:NSFontAttributeName value:self.underlyingFont];
    }
}

-(void)setUnderlyingTextAlignment:(NSTextAlignment)underlyingTextAlignment
{
    _underlyingTextAlignment = underlyingTextAlignment;
    
    if(self.attributedText) {
        NSMutableParagraphStyle *mutableParagraphStyle = [self mutableParagraphStyleFromAttributedString:self.attributedText];
        if(!mutableParagraphStyle) mutableParagraphStyle = [NSMutableParagraphStyle new];
        
        mutableParagraphStyle.alignment = self.underlyingTextAlignment;
        self.attributedText = [self attributedString:self.attributedText withAdddedAttribute:NSParagraphStyleAttributeName value:[mutableParagraphStyle copy]];
    }
}

-(void)setUnderlyingLineBreakMode:(NSLineBreakMode)underlyingLineBreakMode
{
    _underlyingLineBreakMode = underlyingLineBreakMode;
    
    if(self.attributedText) {
        NSMutableParagraphStyle *mutableParagraphStyle = [self mutableParagraphStyleFromAttributedString:self.attributedText];
        if(!mutableParagraphStyle) mutableParagraphStyle = [NSMutableParagraphStyle new];
        
        mutableParagraphStyle.lineBreakMode = self.underlyingLineBreakMode;
        self.attributedText = [self attributedString:self.attributedText withAdddedAttribute:NSParagraphStyleAttributeName value:[mutableParagraphStyle copy]];
    }
}


#pragma mark - Private Methods

-(CGRect)textFrameForCenteredText
{
    //Use intrinsic width in order to size correctly and center, use bounds height as text centers vertically by default.
    
    CGRect textFrame = CGRectMake(0, 0, [self intrinsicContentSize].width, CGRectGetHeight(self.bounds));
    
    //center the textFrame horizontally
    textFrame.origin.x = roundf((CGRectGetWidth(self.bounds)-CGRectGetWidth(textFrame))*0.5);
    
    return textFrame;
}

-(CGRect)textFrameForLeftText
{
    CGRect textFrame = CGRectMake(0, 0, [self intrinsicContentSize].width, CGRectGetHeight(self.bounds));
    
    return textFrame;
}


#pragma mark - Helpers

-(NSMutableParagraphStyle *)mutableParagraphStyleFromAttributedString:(NSAttributedString *)attributedString
{
    if(attributedString) {
        NSParagraphStyle *paragraphStyle = [attributedString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
        if(paragraphStyle) {
            return [paragraphStyle mutableCopy];
        }
    }
    
    return nil;
}

-(NSAttributedString *)attributedString:(NSAttributedString *)attributedString withAdddedAttribute:(NSString *)attribute value:(id)value
{
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    [mutableAttributedString addAttribute:attribute value:value range:NSMakeRange(0, mutableAttributedString.length)];
    return [mutableAttributedString copy];
}


#pragma mark - Layer Methods

+ (Class)layerClass
{
    return [TYMovableCharactersLayer class];
}

- (TYMovableCharactersLayer *)movableCharactersLayer
{
    return (TYMovableCharactersLayer *)self.layer;
}

@end
