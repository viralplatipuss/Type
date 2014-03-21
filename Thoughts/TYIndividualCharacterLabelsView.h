//
//  THTextEntryView.h
//  Thoughts
//
//  Created by Dom Chapman on 3/15/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

/*

 Abstract:      Will represent the given text visually matching a left-adjusted UILabel, but each character consists of its own UILabel.
                Each character's UILabel can be accessed via an index value. Allowing full control and customization.
 
 Optimize:      Right now UILabels are created and destroyed every time text is changed. Should re-use them. Potentially add a cache system.
                Optimize the changes to text so only changed lines need to be updated, also only update from the first character change in a line.
 
 Notes:         - This component is costly to use and shouldn't be used for large amounts of text.
                - Does not support word wrapping. The frame is always resized to fit the labels text.
                - Use \n in the text property's string to force new lines.
 
 TODO:
 
 - Clean up code.
 
 - Find better solution to NSNull entries for new-line characters.
 
 - Implement additional text alignment styles. (center/right adjusted)
 
 */

#import <UIKit/UIKit.h>

@interface TYIndividualCharacterLabelsView : UIView

-(instancetype)init;

@property (nonatomic, copy, readwrite) NSString *text;

@property (nonatomic, strong, readwrite) UIColor *textColor;

@property (nonatomic, strong, readwrite) UIFont *font;

-(UILabel *)labelForCharacterAtIndex:(NSUInteger)index;

//Get content/frame size with certain text & font.
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;

@end
