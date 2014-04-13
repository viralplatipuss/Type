//
//  TYSharedCharactersTransitionView.h
//  Type
//
//  Created by Dom Chapman on 3/28/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

/*

 NOTES
 
    -   Finds matching characters between the start/end texts. Transition fades out/in un-matched characters while moving matching characters
        into correct position for end text with cubic easing.
 
    -   For now this transition left-adjusts the text, and centers it in the view. 
 
 TODO
 
    -   Add support for other alignments/positions in future.
 
*/

#import <UIKit/UIKit.h>

@interface TYSharedCharactersTransitionView : UIView

//Text properties

@property (nonatomic, copy, readwrite) NSString *startText;

@property (nonatomic, copy, readwrite) NSString *endText;

@property (nonatomic, strong, readwrite) UIFont *font;

@property (nonatomic, strong, readwrite) UIColor *textColor;

@property (nonatomic, assign, readwrite) CGFloat textPreferredMaxLayoutWidth;


//Transition Control

//Value between 0-1
@property (nonatomic, assign, readwrite) CGFloat transitionProgress;


@end
