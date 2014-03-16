//
//  THTextEntryView.h
//  Thoughts
//
//  Created by Dom Chapman on 3/15/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THSingleCharacterTextView : UIView

-(instancetype)init;

@property (nonatomic, copy, readwrite) NSString *text;

@end
