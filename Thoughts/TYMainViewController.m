//
//  TYMainViewController.m
//  Type
//
//  Created by Dom Chapman on 3/17/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYMainViewController.h"
#import "TYMainView.h"

@interface TYMainViewController () <UIKeyInput, UITextInputTraits>

@property (nonatomic, strong, readonly) TYMainView *mainView;

@end

@implementation TYMainViewController

@synthesize mainView = _mainView;

-(void)loadView
{
    self.view = self.mainView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainView.toolTipLabel.text = @"Just type.";
    
    [self becomeFirstResponder];
    
    
}

-(TYMainView *)mainView
{
    if(!_mainView) {
        _mainView = [TYMainView new];
    }
    
    return _mainView;
}


#pragma mark - UIKeyInput Methods

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)hasText
{
    return NO;
}

-(void)insertText:(NSString *)text
{
    [self.mainView.typingView becomeFirstResponder];
    self.mainView.typingView.text = text;
}

-(void)deleteBackward
{
    
}


#pragma mark - UITextInputTraits Properties

-(UIKeyboardAppearance)keyboardAppearance
{
    return UIKeyboardAppearanceDark;
}

-(UIReturnKeyType)returnKeyType
{
    return UIReturnKeyDone;
}

-(UIKeyboardType)keyboardType
{
    return UIKeyboardTypeAlphabet;
}

-(BOOL)enablesReturnKeyAutomatically
{
    return YES;
}

@end
