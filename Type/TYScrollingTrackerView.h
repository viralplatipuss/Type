//
//  TYScrollingTrackerView.h
//  Type
//
//  Created by Dom Chapman on 3/28/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

/*
 
 Abstract:  A typically invisible view that tracks touches and mimics the mechanics of an infinitely scrollable view.
            It's not supposed to show content but can inform its delegate about scrolling amount and page changes so
            this information can be used to modify other content based on scrolling actions.
 
 NOTE:      Ideally this would be a gesture-like controller that you'd set a view for rather than a view component.
            But it's done this way to capture the scrolling mechanics (acceleration/decelleration/page changing)
            that Apple have defined.

 */

#import <UIKit/UIKit.h>
@protocol TYScrollingTrackerViewDelegate;


@interface TYScrollingTrackerView : UIView

/*  Page offset will transition to nearest page when let go */
@property (nonatomic, assign, readwrite) BOOL stickToPages;

//pageOffset is a value between 0 and <1 for how far towards the next page on the right the scrolling is.
@property (nonatomic, assign, readonly) CGFloat pageOffset;

@property (nonatomic, weak, readwrite) id <TYScrollingTrackerViewDelegate> delegate;

@end



@protocol TYScrollingTrackerViewDelegate <NSObject>

@optional

-(void)scrollingTrackerViewPageOffsetChanged:(TYScrollingTrackerView *)scrollingTrackerView;

-(void)scrollingTrackerViewChangedPageLeft:(TYScrollingTrackerView *)scrollingTrackerView;

-(void)scrollingTrackerViewChangedPageRight:(TYScrollingTrackerView *)scrollingTrackerView;

@end