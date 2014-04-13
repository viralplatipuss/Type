//
//  TYMainViewController.m
//  Type
//
//  Created by Dom Chapman on 4/7/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYMainViewController.h"
#import "TYMainView.h"


//Constants
static const NSUInteger kCharacterLimit = 60;


//Animations
static const CGFloat kFadingToBeginEditAnimationDuration = 0.2;

static const CGFloat kFadingToEndEditAnimationDuration = 0.2;

static const CGFloat kClearButtonAppearAnimationDuration = 0.25;

static const CGFloat kClearButtonDisappearAnimationDuration = 0.25;

static const CGFloat kCharacterCountAppearAnimationDuration = 0.25;

static const CGFloat kCharacterCountDisappearAnimationDuration = 0.25;


static const CGFloat kAnimationTimersTicksPerSecond = 60;

static const CGFloat kSlidingAnimationsProgressPerTick = 0.03;

static const CGFloat kSlidingAnimationsEndProgress = 0.8; //Cut off animation early to make it feel more responsive


@interface TYMainViewController () <UITextViewDelegate, TYScrollingTrackerViewDelegate>


//View
@property (nonatomic, strong, readonly) TYMainView *mainView;

//Model
@property (nonatomic, strong, readonly) id <THThoughtContext> thoughtContext;

@property (nonatomic, strong, readwrite) id <THThought> thought;

//Editing Flags
@property (nonatomic, assign, readwrite) BOOL editing;

@property (nonatomic, assign, readwrite) BOOL editingThought;

//Animation timers
@property (nonatomic, strong, readwrite) NSTimer *slidingTextToBeginEditAnimationTimer;

@property (nonatomic, strong, readwrite) NSTimer *slidingTextToEndEditAnimationTimer;

//Gestures
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapGesture;


@end

@implementation TYMainViewController

@synthesize mainView = _mainView,
            tapGesture = _tapGesture;


#pragma mark - Init

-(instancetype)initWithThoughtContext:(id<THThoughtContext>)thoughtContext
{
    self = [super init];
    if(self) {
        _thoughtContext = thoughtContext;
    }
    
    return self;
}


#pragma mark - View Methods

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Model Setup
    
    self.thought = [self.thoughtContext anyThought];

    //View Setup
    
    [self.mainView addGestureRecognizer:self.tapGesture];
    
    [self.mainView.textView becomeFirstResponder];
    self.mainView.textView.hidden = YES;
    self.mainView.textView.delegate = self;
    self.mainView.textView.textContainerInset = UIEdgeInsetsMake(-1.5, 0, 0, 0); //Tweak, matches TextView to textSlidingView better
    //self.mainView.textView.enablesReturnKeyAutomatically = YES; //Seems to be a weird apple bug in this, don't use for now
    
    self.mainView.clearLabel.hidden = YES;
    
    self.mainView.characterCountLabel.hidden = YES;
    
    self.mainView.scrollingTrackerView.delegate = self;
    
    //Make view account for status bar if using.
    if(![UIApplication sharedApplication].statusBarHidden) {
        self.mainView.headerInset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    }
    
}

-(void)loadView
{
    self.view = self.mainView;
}

-(TYMainView *)mainView
{
    if(!_mainView) {
        _mainView = [TYMainView new];
    }
    
    return _mainView;
}


#pragma mark - Private Properties

-(void)setThought:(id<THThought>)thought
{
    _thought = thought;
    
    [self updateTransitionViewsText];
}

-(UITapGestureRecognizer *)tapGesture
{
    if(!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    }
    
    return _tapGesture;
}


#pragma mark - Private Methods

-(void)updateCharacterCount
{
    NSInteger charactersLeft = kCharacterLimit-self.mainView.textView.text.length;
    self.mainView.characterCountLabel.text = [NSString stringWithFormat:@"%li",(long)charactersLeft];
}

-(void)updateTransitionViewsText
{
    self.mainView.transitionView.startText = self.thought.text;
    self.mainView.transitionView.endText = self.thought.nextThought.text;
}

-(void)viewTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint tapPoint = [gestureRecognizer locationInView:self.mainView];
    
    if([self.mainView.headerView pointInside:tapPoint withEvent:nil]) {
        [self headerViewTapped];
    }
}

-(void)headerViewTapped
{
    if(!self.editing) {
        return;
    }
    
    //Clear textView
    self.mainView.textView.text = @"";
    [self textViewDidChange:self.mainView.textView];
}


#pragma mark - ScrollingTrackerView Delegate Methods

-(void)scrollingTrackerViewPageOffsetChanged:(TYScrollingTrackerView *)scrollingTrackerView
{
    self.mainView.transitionView.transitionProgress = scrollingTrackerView.pageOffset;
}

-(void)scrollingTrackerViewChangedPageLeft:(TYScrollingTrackerView *)scrollingTrackerView
{
    self.thought = self.thought.previousThought;
}

-(void)scrollingTrackerViewChangedPageRight:(TYScrollingTrackerView *)scrollingTrackerView
{
    self.thought = self.thought.nextThought;
}


#pragma mark - TextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(!self.editing) {
        
        //Not editing
        
        if(self.mainView.transitionView.transitionProgress != 0) {
            return NO;
        }
        
        if(!text.length) {
            //Pressed backspace
            if(self.thought) {
                
                self.editingThought = YES;
                self.editing = YES;
                
                
                self.mainView.textView.text = self.thought.text;
                [self textViewDidChange:self.mainView.textView];
                
                [self clearButtonAppearAnimation];
                [self characterCountAppearAnimation];
                [self slidingTextToBeginEditAnimation];
                
                return NO;
            }
        }
        
        
        NSString *trimmedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(trimmedText.length) {
            //Started typing fresh thought
            
            self.editingThought = NO;
            self.editing = YES;
            
            [self clearButtonAppearAnimation];
            [self characterCountAppearAnimation];
            [self fadeToBeginEditAnimation];
            
            return YES;
        }
        
        
        return NO;
        
    }else {
        
        //Editing
        
        if([text isEqualToString:@"\n"]) {
           //Pressed Done
            
            if(self.mainView.textView.text.length) {
                
                THThoughtSpecification *thoughtSpec = [THThoughtSpecification new];
                thoughtSpec.text = self.mainView.textView.text;
                
                if(self.editingThought) {
                    
                    //Replace thought
                    id <THThought> replacedThought = [self.thought.previousThought createThoughtAfterThisWithSpecification:thoughtSpec];
                    [self.thought deleteThought];
                    self.thought = replacedThought;
                    
                    //Create new thought
                }else if(self.thought) {
                        self.thought = [self.thought createThoughtAfterThisWithSpecification:thoughtSpec];
                    }else {
                        self.thought = [self.thoughtContext createThoughtWithSpecification:thoughtSpec];
                    }
                
            }
            
            self.editing = NO;
            self.editingThought = NO;
            
            [self clearButtonDisappearAnimation];
            [self characterCountDisappearAnimation];
            [self slidingTextToEndEditAnimation];
            
            //Clear textView
            self.mainView.textView.text = @"";
            
            return NO;
        }
        
        return YES;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    //Disable Ligands (as transition style can't use them)
    self.mainView.textView.attributedText = [self attributedStringWithLigandsDisabled:self.mainView.textView.attributedText];
    
    //Remove any whitespace from the start of the entered text (UX choice)
    [self trimBeginningWhitespaceFromTextView:self.mainView.textView keepCaratPosition:YES];
    
    //Trim the text down (if needed) to fit within the character limit
    [self trimTextView:self.mainView.textView toFitCharacterLimit:kCharacterLimit keepCaratPosition:YES];
    
    
    [self updateCharacterCount];
    
    
    if(!self.mainView.textView.text.length) {
        
        if(self.editingThought) {
            id <THThought> previousThought = self.thought.previousThought;
            [self.thought deleteThought];
            self.thought = previousThought;
        }
        
        self.editing = NO;
        self.editingThought = NO;
        
        [self clearButtonDisappearAnimation];
        [self characterCountDisappearAnimation];
        [self fadeToEndEditAnimation];
    }
}


#pragma mark - Animation Methods

-(void)fadeToBeginEditAnimation
{
    //Prepare animation
    self.mainView.scrollingTrackerView.hidden = YES;
    
    self.mainView.transitionView.hidden = NO;
    self.mainView.transitionView.alpha = 1;
    
    self.mainView.textView.hidden = NO;
    self.mainView.textView.alpha = 0;
    
    //Animate
    [UIView animateWithDuration:kFadingToBeginEditAnimationDuration animations:^{
        
        self.mainView.textView.alpha = 1;
        
        self.mainView.transitionView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        self.mainView.transitionView.hidden = YES;
        self.mainView.transitionView.alpha = 1;
        
    }];
}

-(void)fadeToEndEditAnimation
{
    //Prepare Animation
    self.mainView.scrollingTrackerView.hidden = YES;
    
    self.mainView.textView.hidden = NO;
    self.mainView.textView.alpha = 1;
    
    self.mainView.transitionView.hidden = NO;
    self.mainView.transitionView.alpha = 0;
    
    //Animate
    [UIView animateWithDuration:kFadingToEndEditAnimationDuration animations:^{
        
        self.mainView.textView.alpha = 0;
        
        self.mainView.transitionView.alpha = 1;
        
    } completion:^(BOOL finished) {
    
        self.mainView.scrollingTrackerView.hidden = NO;
        
        self.mainView.textView.hidden = YES;
        self.mainView.textView.alpha = 1;
        
    }];
}

-(void)prepareSlidingTextAnimation
{
    self.mainView.textSlidingView.hidden = NO;
    self.mainView.textSlidingView.text = self.mainView.textView.text;
    self.mainView.textSlidingView.transitionProgress = 0;
    
    self.mainView.transitionView.hidden = YES;
    
    self.mainView.scrollingTrackerView.hidden = YES;
    
    self.mainView.textView.hidden = YES;
}

-(void)slidingTextToBeginEditAnimation
{
    //If interrupting opposite animation timer, invalidate it.
    if(self.slidingTextToEndEditAnimationTimer && self.slidingTextToEndEditAnimationTimer.isValid) {
        [self.slidingTextToEndEditAnimationTimer invalidate];
        self.slidingTextToEndEditAnimationTimer = nil;
    }
    
    
    //Prepare Animation
    [self prepareSlidingTextAnimation];
    
    self.mainView.textSlidingView.startPosition = TYSlidingTextPositionTransitionViewTextPositionCenter;
    self.mainView.textSlidingView.endPosition = TYSlidingTextPositionTransitionViewTextPositionLeft;
    self.mainView.textSlidingView.startTextInsetX = 0;
    self.mainView.textSlidingView.endTextInsetX = self.mainView.textViewPaddingX;
    
    
    //Animate
    self.slidingTextToBeginEditAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/kAnimationTimersTicksPerSecond target:self selector:@selector(slidingTextToBeginEditAnimationStep:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.slidingTextToBeginEditAnimationTimer forMode:NSRunLoopCommonModes];
}

-(void)slidingTextToEndEditAnimation
{
    //If interrupting opposite animation timer, invalidate it.
    if(self.slidingTextToBeginEditAnimationTimer && self.slidingTextToBeginEditAnimationTimer.isValid) {
        [self.slidingTextToBeginEditAnimationTimer invalidate];
        self.slidingTextToBeginEditAnimationTimer = nil;
    }
    
    //Animation preparation
    [self prepareSlidingTextAnimation];
    
    self.mainView.textSlidingView.startPosition = TYSlidingTextPositionTransitionViewTextPositionLeft;
    self.mainView.textSlidingView.endPosition = TYSlidingTextPositionTransitionViewTextPositionCenter;
    self.mainView.textSlidingView.startTextInsetX = self.mainView.textViewPaddingX;
    self.mainView.textSlidingView.endTextInsetX = 0;

    
    //Animate
    self.slidingTextToEndEditAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/kAnimationTimersTicksPerSecond target:self selector:@selector(slidingTextToEndEditAnimationStep:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.slidingTextToEndEditAnimationTimer forMode:NSRunLoopCommonModes];
}

-(void)slidingTextToBeginEditAnimationStep:(NSTimer *)timer
{
    self.mainView.textSlidingView.transitionProgress += kSlidingAnimationsProgressPerTick;
    if(self.mainView.textSlidingView.transitionProgress > kSlidingAnimationsEndProgress) {
        [timer invalidate];
        
        self.mainView.textSlidingView.hidden = YES;
        self.mainView.transitionView.hidden = YES;
        self.mainView.scrollingTrackerView.hidden = YES;
        self.mainView.textView.hidden = NO;
        
    }
}

-(void)slidingTextToEndEditAnimationStep:(NSTimer *)timer
{
    self.mainView.textSlidingView.transitionProgress += kSlidingAnimationsProgressPerTick;
    if(self.mainView.textSlidingView.transitionProgress > kSlidingAnimationsEndProgress) {
        [timer invalidate];
        
        self.mainView.textSlidingView.hidden = YES;
        self.mainView.transitionView.hidden = NO;
        self.mainView.scrollingTrackerView.hidden = NO;
        self.mainView.textView.hidden = YES;
        
    }
}

-(void)clearButtonAppearAnimation
{
    //Animation Setup
    self.mainView.clearLabel.hidden = NO;
    self.mainView.clearLabel.alpha = 0;
    self.mainView.clearLabel.layer.affineTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -CGRectGetHeight(self.mainView.clearLabel.bounds)*0.5);
    
    self.mainView.headerLabel.hidden = NO;
    self.mainView.headerLabel.alpha = 1;
    self.mainView.headerLabel.layer.affineTransform = CGAffineTransformIdentity;
    
    self.mainView.headerView.backgroundColor = [UIColor clearColor];
    
    //Animate
    
    [UIView animateWithDuration:kClearButtonAppearAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.mainView.clearLabel.alpha = 1;
        self.mainView.clearLabel.layer.affineTransform = CGAffineTransformIdentity;
        
        self.mainView.headerLabel.alpha = 0;
        self.mainView.headerLabel.layer.affineTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, CGRectGetHeight(self.mainView.headerLabel.bounds)*0.5);
        
        self.mainView.headerView.backgroundColor = self.mainView.clearHeaderColor;
        
    } completion:^(BOOL finished) {
        
            self.mainView.headerLabel.hidden = YES;
            self.mainView.headerLabel.alpha = 1;
        
    }];
    
}

-(void)clearButtonDisappearAnimation
{
    //Animation Setup
    self.mainView.clearLabel.hidden = NO;
    self.mainView.clearLabel.alpha = 1;
    self.mainView.clearLabel.layer.affineTransform = CGAffineTransformIdentity;
    
    self.mainView.headerLabel.hidden = NO;
    self.mainView.headerLabel.alpha = 0;
    self.mainView.headerLabel.layer.affineTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -CGRectGetHeight(self.mainView.headerLabel.bounds)*0.5);
    
    self.mainView.headerView.backgroundColor = self.mainView.clearHeaderColor;
    
    //Animate
    
    [UIView animateWithDuration:kClearButtonDisappearAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.mainView.clearLabel.alpha = 0;
        self.mainView.clearLabel.layer.affineTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, CGRectGetHeight(self.mainView.clearLabel.bounds)*0.5);
        
        self.mainView.headerLabel.alpha = 1;
        self.mainView.headerLabel.layer.affineTransform = CGAffineTransformIdentity;
        
        self.mainView.headerView.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
    
        self.mainView.clearLabel.hidden = YES;
        self.mainView.clearLabel.alpha = 1;
        
    }];
}

-(void)characterCountAppearAnimation
{
    //Prepare Animation
    self.mainView.characterCountLabel.hidden = NO;
    self.mainView.characterCountLabel.alpha = 0;
    
    [UIView animateWithDuration:kCharacterCountAppearAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.mainView.characterCountLabel.alpha = 1;
        
    } completion:nil];
}

-(void)characterCountDisappearAnimation
{
    //Prepare Animation
    self.mainView.characterCountLabel.hidden = NO;
    self.mainView.characterCountLabel.alpha = 1;
    
    [UIView animateWithDuration:kCharacterCountDisappearAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.mainView.characterCountLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        self.mainView.characterCountLabel.hidden = YES;
        self.mainView.characterCountLabel.alpha = 1;
        
    }];
}


#pragma mark - Keyboard Notification Methods

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSDictionary *info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSNumber *animationDurationNumber = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat animationDuration = [animationDurationNumber floatValue];
    
    [self.mainView layoutIfNeeded];
   
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.mainView.contentViewBottomConstraint.constant = -keyboardSize.height;
        [self.mainView layoutIfNeeded];
        
    } completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    
    NSNumber *animationDurationNumber = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat animationDuration = [animationDurationNumber floatValue];
    
    [self.mainView layoutIfNeeded];
    
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.mainView.contentViewBottomConstraint.constant = 0;
        [self.mainView layoutIfNeeded];
        
    } completion:nil];
    
}


#pragma mark - Private Helpers

-(NSAttributedString *)attributedStringWithLigandsDisabled:(NSAttributedString *)attributedString
{
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    
    [mutableAttributedString addAttribute:NSLigatureAttributeName value:@0 range:NSMakeRange(0, mutableAttributedString.length)];
    
    return [mutableAttributedString copy];
}

-(void)trimBeginningWhitespaceFromTextView:(UITextView *)textView keepCaratPosition:(BOOL)keepCaratPosition
{
    NSRange selectedRange = textView.selectedRange;
    
    while([self didTrimFirstCharacterIfWhitespaceInTextView:textView]) {
        if(selectedRange.location > 0) {
            selectedRange.location --;
        }
    }
    
    if(keepCaratPosition) {
        textView.selectedRange = selectedRange;
    }
}

-(BOOL)didTrimFirstCharacterIfWhitespaceInTextView:(UITextView *)textView
{
    if(!textView.text.length) return NO;
    
    NSString *firstCharacter = [textView.text substringToIndex:1];
    if ([self isStringWhiteSpace:firstCharacter]) {
        
        if(textView.text.length > 1) {
            textView.text = [textView.text substringFromIndex:1];
        }else {
            textView.text = @"";
        }
        
        return YES;
    }
    
    return NO;
}

-(void)trimTextView:(UITextView *)textView toFitCharacterLimit:(NSUInteger)characterLimit keepCaratPosition:(BOOL)keepCaratPosition
{
    if(textView.text.length <= characterLimit) {
        return;
    }
    
    NSRange selectedRange = textView.selectedRange;
    
    textView.text = [textView.text substringToIndex:characterLimit];
    
    if(keepCaratPosition) {
        textView.selectedRange = selectedRange;
    }
}

-(BOOL)isStringWhiteSpace:(NSString *)string
{
    if(!string.length) return NO;
    
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(!trimmedString.length) {
        return YES;
    }
    
    return NO;
}

@end
