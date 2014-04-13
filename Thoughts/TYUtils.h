//
//  TYUtils.h
//  Type
//
//  Created by Dom Chapman on 3/21/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYUtils : NSObject

/* Rounds a rect to the nearest integer. (different from integral, which ceils) */
+(CGRect)roundRect:(CGRect)rect;

+(CGPoint)roundPoint:(CGPoint)point;

+(CGPoint)multiplyPoint:(CGPoint)point by:(CGFloat)multiplier;

+(CGPoint)addPoint:(CGPoint)pointA toPoint:(CGPoint)pointB;

+(CGPoint)subtractPoint:(CGPoint)pointToSubtract fromPoint:(CGPoint)point;

+(CGSize)ceilSize:(CGSize)size;

@end
