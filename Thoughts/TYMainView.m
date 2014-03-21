//
//  TYMainView.m
//  Type
//
//  Created by Dom Chapman on 3/17/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYMainView.h"
#import "UIColor+HexString.h"

static NSString * const kBackgroundColor = @"3497da";

static NSString * const kApplicationFontName = @"Raleway-Light";

static const CGFloat kToolTipFontSize = 12;


@interface TYMainView() <UITextViewDelegate>


//Containers


@property (nonatomic, strong, readonly) UIView *contentView;

//Header Subviews
@property (nonatomic, strong, readonly) UIView *topLine;

@property (nonatomic, strong, readonly) UILabel *toolTipLabel;

//Content Subviews


//Misc
@property (nonatomic, strong, readwrite) NSLayoutConstraint *contentViewBottomConstraint;


@end

@implementation TYMainView

@synthesize headerView = _headerView, contentView = _contentView, topLine = _topLine, toolTipLabel = _toolTipLabel, textView = _textView, contentViewBottomConstraint = _contentViewBottomConstraint;

-(void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"bing");
    
    NSLog(@"%@",NSStringFromCGSize(self.textView.contentSize));
    
    [self.textView caretRectForPosition:nil];
    
    UITextRange *textRange = [self.textView textRangeFromPosition:self.textView.beginningOfDocument toPosition:self.textView.endOfDocument];
    
    CGRect rect = [self.textView firstRectForRange:textRange];
    
    NSLog(@"%@",NSStringFromCGRect(rect));
    
    //self.textView
    
    if([textView.text isEqualToString:@"China is a countryfor."]) {
        
        NSLog(@"BOOP");
        //self.textView.frame = rect;
        [self.textView removeFromSuperview];
        [self addSubview:self.textView];
        [self setNeedsUpdateConstraints];
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self registerForKeyboardNotifications];
        
        [self.textView becomeFirstResponder];
    }
    return self;
}

-(void)setupView
{
    self.backgroundColor = [UIColor colorWithHexString:kBackgroundColor];
    
    [self addSubview:self.contentView];
    [self addSubview:self.headerView];
    
    [self.contentView addSubview:self.textView];
    
    [self.headerView addSubview:self.toolTipLabel];
    [self.headerView addSubview:self.topLine];
    
    [self setupConstraints];
}

-(UIView *)headerView
{
    if(!_headerView) {
        _headerView = [UIView new];
    }
    
    return _headerView;
}

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    
    return _contentView;
}

-(UILabel *)toolTipLabel
{
    if(!_toolTipLabel) {
        _toolTipLabel = [UILabel new];
        _toolTipLabel.textAlignment = NSTextAlignmentCenter;
        _toolTipLabel.font = [UIFont fontWithName:kApplicationFontName size:kToolTipFontSize];
        _toolTipLabel.textColor = [UIColor colorWithRed:0/255.0 green:47/255.0 blue:181/255.0 alpha:1];
        _toolTipLabel.text = @"Just Type.";
    }
    
    return _toolTipLabel;
}

-(UIView *)topLine
{
    if(!_topLine) {
        _topLine = [UIView new];
        _topLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    }
    
    return _topLine;
}

-(UITextView *)textView
{
    if(!_textView) {
        _textView = [UITextView new];
        _textView.backgroundColor = [UIColor redColor];
        _textView.font = [UIFont fontWithName:kApplicationFontName size:37];
        _textView.keyboardAppearance = UIKeyboardAppearanceDark;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.enablesReturnKeyAutomatically = YES;
        
        _textView.delegate = self;

        
        _textView.scrollEnabled = NO;

        _textView.tintColor = [UIColor greenColor];
        
            }
    
    return _textView;
}

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSDictionary *info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSNumber *animationDurationNumber = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat animationDuration = [animationDurationNumber floatValue];
    
    [self layoutIfNeeded];
    self.contentViewBottomConstraint.constant = -keyboardSize.height;
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self layoutIfNeeded];
        
    } completion:nil];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    
    NSNumber *animationDurationNumber = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat animationDuration = [animationDurationNumber floatValue];
    
    [self layoutIfNeeded];
    self.contentViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self layoutIfNeeded];
        
    } completion:nil];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setupConstraints
{
    
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.topLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolTipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSDictionary *views = @{
                            @"headerView": self.headerView,
                            @"contentView": self.contentView,
                            
                            @"textView": self.textView,
                            
                            @"topLine": self.topLine,
                            @"toolTipLabel": self.toolTipLabel,
                            };
    
    
    NSDictionary *metrics = @{
                              @"toolTipLabel_offset_y":@(27.5),
                              @"toolTipLabel_topLine_gap": @(10),
                              @"topLine_height":@(0.5),
                              
                              };
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerView]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:metrics views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView][contentView]" options:0 metrics:metrics views:views]];
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolTipLabel]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topLine]|" options:0 metrics:metrics views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-toolTipLabel_offset_y-[toolTipLabel]-toolTipLabel_topLine_gap-[topLine(topLine_height)]|" options:0 metrics:metrics views:views]];
    
    //Bottom constraint (tracked for change on keyboard)
    self.contentViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self addConstraint:self.contentViewBottomConstraint];
    
}

@end
