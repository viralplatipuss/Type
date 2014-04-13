//
//  TYUtils.m
//  Type
//
//  Created by Dom Chapman on 3/21/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYUtils.h"

@implementation TYUtils

+(CGRect)roundRect:(CGRect)rect
{
    return CGRectMake(round(CGRectGetMinX(rect)), round(CGRectGetMinY(rect)), round(CGRectGetWidth(rect)), round(CGRectGetHeight(rect)));
}


+(CGPoint)roundPoint:(CGPoint)point
{
    return CGPointMake(round(point.x), round(point.y));
}

+(CGPoint)multiplyPoint:(CGPoint)point by:(CGFloat)multiplier
{
    point.x *= multiplier;
    point.y *= multiplier;
    
    return point;
}

+(CGPoint)addPoint:(CGPoint)pointA toPoint:(CGPoint)pointB
{
    return CGPointMake(pointA.x+pointB.x, pointA.y+pointB.y);
}

+(CGPoint)subtractPoint:(CGPoint)pointToSubtract fromPoint:(CGPoint)point
{
    return CGPointMake(point.x-pointToSubtract.x, point.y-pointToSubtract.y);
}

+(CGSize)ceilSize:(CGSize)size
{
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

@end
