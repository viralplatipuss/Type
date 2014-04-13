//
//  TYMovableCharactersLayer.h
//  Type
//
//  Created by Dom Chapman on 3/26/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

/*
 
 NOTES:
 
 -  Will automatically disable ligatures on attributedString.
    Cannot position individual characters if ligatures are enabled.
 
 */

#import <QuartzCore/QuartzCore.h>
@protocol TYMovableCharactersLayerDataSource;


@interface TYMovableCharactersLayer : CALayer

@property (nonatomic, weak, readwrite) id <TYMovableCharactersLayerDataSource> dataSource;

//Dictionary of CGPoints for visible characters, indexed by character's string index, relative to bounds, sans offsets
-(NSDictionary *)calculateVisibleCharacterPositions;

-(CGSize)sizeThatFitsAttributedString:(NSAttributedString *)attributedString constrainedToSize:(CGSize)constraintSize;

@end



@protocol TYMovableCharactersLayerDataSource <NSObject>

@required

-(NSAttributedString *)attributedStringForMovableCharactersLayer:(TYMovableCharactersLayer *)movableCharactersLayer;


@optional

-(NSDictionary *)positionOffsetsForCharacterIndexesForMovableCharactersLayer:(TYMovableCharactersLayer *)movableCharactersLayer;

/*
    The frame the text is constrained to on layout, not including position offsets. (Passing CGRectZero will make the layer use its bounds)
 */
-(CGRect)textFrameForMovableCharactersLayer:(TYMovableCharactersLayer *)movableCharactersLayer;


@end