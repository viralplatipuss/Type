//
//  TYMovableCharactersLabel.h
//  Type
//
//  Created by Dom Chapman on 3/26/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//


/*
 
 NOTES:
 
 -  Does not support ligatures. It will automatically disable them.
    No way to move individual characters if they are in ligatures. :(
 
 -  IntrinsicContentSize and SizeToFit do not account for the offset characters.
    It sizes for the original label.
 
 */


#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, TYMovableCharactersLabelTextPosition) {
    TYMovableCharactersLabelTextPositionLeft,
    TYMovableCharactersLabelTextPositionCenter
};


@interface TYMovableCharactersLabel : UIView


//Label's text
@property (nonatomic, copy, readwrite) NSString *text;


/*
    Dictionary of CGPoint values for offsetting each character in the label from its standard position.
    Key is an NSNumber of the character's index in the text.
 */
@property (nonatomic, strong, readwrite) NSDictionary *positionOffsetsForCharacterIndexes;

/*
    Dictionary of CGPoint values representing the position (not including offsets) of each visible character in the label's text.
    Positions are relative to the labels bounds.
    Keys are NSNumbers of the character's string index.
*/
-(NSDictionary *)calculateVisibleCharacterPositions;


//Text attributes

@property (nonatomic, strong, readwrite) UIFont *font;

@property (nonatomic, strong, readwrite) UIColor *textColor;

@property (nonatomic, assign, readwrite) NSTextAlignment textAlignment;

@property (nonatomic, assign, readwrite) NSLineBreakMode lineBreakMode;


//Direct access to the attributed text
@property (nonatomic, copy, readwrite) NSAttributedString *attributedText;


//Maximum width of the text (line breaking width) - Still applies if not using layout constraints
@property (nonatomic, assign, readwrite) CGFloat preferredMaxLayoutWidth;


-(void)sizeToFit;
-(CGSize)intrinsicContentSize;


/*
    The following properties are useful if you size the label bigger than its intrinsic content size (so offset characters aren't clipped!)
 */

//Position the text in the label's bounds (useful if you want to center left-adjusted text)
@property (nonatomic, assign, readwrite) TYMovableCharactersLabelTextPosition textPosition;

//Inset the text's position
@property (nonatomic, assign, readwrite) CGPoint textInset;





@end
