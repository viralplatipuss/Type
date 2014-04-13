//
//  TYMainView.m
//  Type
//
//  Created by Dom Chapman on 4/10/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYMainView.h"
#import "UIColor+HexString.h"


//Default Text
static NSString * const kHeaderDefaultText = @"Type.";

static NSString * const kClearLabelText = @"Tap to clear.";


//Colors/Alpha
static NSString * const kBackgroundColor = @"3497da";

static NSString * const kMainTextColor = @"002fb5";

static NSString * const kTextViewTintColor = @"68ffff";

static NSString * const kHeaderTextColor = @"002fb5";

static const CGFloat kHeaderBottomLineAlpha = 0.2;

static const CGFloat kClearHeaderBackgroundAlpha = 0.4;

static const CGFloat kCharacterCountTextAlpha = 0.4;


//Font Names
static NSString * const kMainFontName = @"Raleway-Light";


//Font Sizes
static const CGFloat kMainFontSize = 37;

static const CGFloat kHeaderFontSize = 12;

static const CGFloat kCharacterCountFontSize = 28;


//Layout/Padding
static const CGFloat kHeaderBottomLineHeight = 0.5;

static const CGFloat kHeaderContentHeight = 29.5; //Height of the header view, not including inset or bottom line.

static const CGFloat kTextViewPaddingX = 6;

static const CGFloat kCharacterCountPadding = 6;



@interface TYMainView()


//Container Views
@property (nonatomic, strong, readonly) UIView *headerContentsView;

@property (nonatomic, strong, readonly) UIView *contentView;


//Asthetic Views
@property (nonatomic, strong, readonly) UIView *headerBottomLine;


//Fonts
@property (nonatomic, strong, readonly) UIFont *mainFont;

@property (nonatomic, strong, readonly) UIFont *headerFont;

@property (nonatomic, strong, readonly) UIFont *characterCountFont;


//Colors
@property (nonatomic, strong, readonly) UIColor *headerTextColor;

@property (nonatomic, strong, readonly) UIColor *mainTextColor;


//Constraints
@property (nonatomic, strong, readwrite) NSLayoutConstraint *headerContentsViewTopConstraint;

@property (nonatomic, strong, readwrite) NSLayoutConstraint *contentViewBottomConstraint;


@end

@implementation TYMainView

@synthesize headerView = _headerView,
            headerContentsView = _headerContentsView,
            contentView = _contentView,
            headerBottomLine = _headerBottomLine,
            clearLabel = _clearLabel,
            headerLabel = _headerLabel,
            characterCountLabel = _characterCountLabel,
            transitionView = _transitionView,
            textSlidingView = _textSlidingView,
            scrollingTrackerView = _scrollingTrackerView,
            textView = _textView;


#pragma mark - Init

-(instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


#pragma mark - View Setup

-(void)setupView
{
    self.backgroundColor = [UIColor colorWithHexString:kBackgroundColor];
    
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.transitionView];
    [self.contentView addSubview:self.textSlidingView];
    [self.contentView addSubview:self.characterCountLabel];
    
    [self addSubview:self.contentView];
    
    [self.headerContentsView addSubview:self.headerLabel];
    [self.headerContentsView addSubview:self.clearLabel];
    [self.headerView addSubview:self.headerContentsView];
    
    [self.headerView addSubview:self.headerBottomLine];
    [self addSubview:self.headerView];
    
    [self addSubview:self.scrollingTrackerView];
    
    [self setupConstraints];
}


#pragma mark - Public Properties

-(CGFloat)textViewPaddingX
{
    return kTextViewPaddingX;
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    //If view's size changes, make sure text layout width is correctly set to match the textView's width
    self.transitionView.textPreferredMaxLayoutWidth = CGRectGetWidth(self.textView.bounds);
    self.textSlidingView.preferredMaxLayoutWidth = CGRectGetWidth(self.textView.bounds);
}

-(CGFloat)headerInset
{
    return self.headerContentsViewTopConstraint.constant;
}

-(void)setHeaderInset:(CGFloat)headerInset
{
    self.headerContentsViewTopConstraint.constant = headerInset;
}

-(UIColor *)clearHeaderColor
{
    return [[UIColor redColor] colorWithAlphaComponent:kClearHeaderBackgroundAlpha];
}


#pragma mark - Private Properties

-(UIFont *)mainFont
{
    return [UIFont fontWithName:kMainFontName size:kMainFontSize];
}

-(UIFont *)headerFont
{
    return [UIFont fontWithName:kMainFontName size:kHeaderFontSize];
}

-(UIFont *)characterCountFont
{
    return [UIFont fontWithName:kMainFontName size:kCharacterCountFontSize];
}

-(UIColor *)headerTextColor
{
    return [UIColor colorWithHexString:kHeaderTextColor];
}

-(UIColor *)mainTextColor
{
    return [UIColor colorWithHexString:kMainTextColor];
}


//Views

-(UIView *)headerView
{
    if(!_headerView) {
        _headerView = [UIView new];
    }
    
    return _headerView;
}

-(UIView *)headerContentsView
{
    if(!_headerContentsView) {
        _headerContentsView = [UIView new];
    }
    
    return _headerContentsView;
}

-(UIView *)contentView
{
    if(!_contentView) {
        _contentView = [UIView new];
    }
    
    return _contentView;
}

-(UIView *)headerBottomLine
{
    if(!_headerBottomLine) {
        _headerBottomLine = [UIView new];
        _headerBottomLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:kHeaderBottomLineAlpha];
    }
    
    return _headerBottomLine;
}

-(UILabel *)headerLabel
{
    if(!_headerLabel) {
        _headerLabel = [UILabel new];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.font = self.headerFont;
        _headerLabel.textColor = self.headerTextColor;
        _headerLabel.text = kHeaderDefaultText;
    }
    
    return _headerLabel;
}

-(UILabel *)clearLabel
{
    if(!_clearLabel) {
        _clearLabel = [UILabel new];
        _clearLabel.textAlignment = NSTextAlignmentCenter;
        _clearLabel.font = self.headerFont;
        _clearLabel.textColor = [UIColor whiteColor];
        _clearLabel.text = kClearLabelText;
    }
    
    return _clearLabel;
}

-(UILabel *)characterCountLabel
{
    if(!_characterCountLabel) {
        _characterCountLabel = [UILabel new];
        _characterCountLabel.textAlignment = NSTextAlignmentRight;
        _characterCountLabel.font = self.characterCountFont;
        _characterCountLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:kCharacterCountTextAlpha];
    }
    
    return _characterCountLabel;
}

-(UITextView *)textView
{
    if(!_textView) {
        _textView = [UITextView new];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.tintColor = [UIColor colorWithHexString:kTextViewTintColor];
        _textView.textColor = self.mainTextColor;
        _textView.font = self.mainFont;
        _textView.keyboardAppearance = UIKeyboardAppearanceDark;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.scrollEnabled = NO;
    }
    
    return _textView;
}

-(TYSlidingTextPositionTransitionView *)textSlidingView
{
    if(!_textSlidingView) {
        _textSlidingView = [TYSlidingTextPositionTransitionView new];
        _textSlidingView.font = self.mainFont;
        _textSlidingView.textColor = self.mainTextColor;
    }
    
    return _textSlidingView;
}

-(TYSharedCharactersTransitionView *)transitionView
{
    if(!_transitionView) {
        _transitionView = [TYSharedCharactersTransitionView new];
        _transitionView.font = self.mainFont;
        _transitionView.textColor = self.mainTextColor;
    }
    
    return _transitionView;
}

-(TYScrollingTrackerView *)scrollingTrackerView
{
    if(!_scrollingTrackerView) {
        _scrollingTrackerView = [TYScrollingTrackerView new];
    }
    
    return _scrollingTrackerView;
}


#pragma mark - Constraints

-(void)setupConstraints
{
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerContentsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.clearLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerBottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    self.characterCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.transitionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textSlidingView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollingTrackerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSDictionary *views = @{
                            @"headerView": self.headerView,
                            @"headerContentsView": self.headerContentsView,
                            @"contentView": self.contentView,
                            
                            @"headerLabel": self.headerLabel,
                            @"clearLabel": self.clearLabel,
                            @"characterCountLabel": self.characterCountLabel,
                            @"headerBottomLine": self.headerBottomLine,
                            
                            @"textView": self.textView,
                            @"textSlidingView": self.textSlidingView,
                            @"transitionView": self.transitionView,
                            @"scrollingTrackerView": self.scrollingTrackerView
                            
                            };
    
    NSDictionary *metrics = @{
                              @"headerHeight": @(kHeaderContentHeight),
                              @"headerBottomLineHeight": @(kHeaderBottomLineHeight),
                              @"textViewPaddingX": @(kTextViewPaddingX),
                              @"characterCountPadding": @(kCharacterCountPadding)
                              };
    
    
    //ScrollingTrackerView
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollingTrackerView]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollingTrackerView]|" options:0 metrics:metrics views:views]];
    
    //TransitionView
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[transitionView]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[transitionView]|" options:0 metrics:metrics views:views]];
    
    //TextSlidingView
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textSlidingView]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textSlidingView]|" options:0 metrics:metrics views:views]];
    
    //TextView
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-textViewPaddingX-[textView]-textViewPaddingX-|" options:0 metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    //CharacterCountLabel
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[characterCountLabel]-characterCountPadding-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[characterCountLabel]-characterCountPadding-|" options:0 metrics:metrics views:views]];
    
    //ClearLabel
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[clearLabel]|" options:0 metrics:metrics views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.clearLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.headerContentsView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    //HeaderLabel
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerLabel]|" options:0 metrics:metrics views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.headerContentsView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    //HeaderContentsView
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerContentsView]|" options:0 metrics:metrics views:views]];
    
    self.headerContentsViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.headerContentsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeTop multiplier:1 constant:self.headerInset];
    
    [self addConstraint:self.headerContentsViewTopConstraint];
    
    //HeaderBottomLine
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerBottomLine]|" options:0 metrics:metrics views:views]];
    
    
    //HeaderView
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerView]|" options:0 metrics:metrics views:views]];
    
    
    //ContentView
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:metrics views:views]];
    
    self.contentViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self addConstraint:self.contentViewBottomConstraint];
    
    
    //Multiple Views
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView][contentView]" options:0 metrics:metrics views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[headerContentsView(headerHeight)][headerBottomLine(headerBottomLineHeight)]|" options:0 metrics:metrics views:views]];
    
    
}

@end
