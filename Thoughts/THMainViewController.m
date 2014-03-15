//
//  THThoughtsViewController.m
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THMainViewController.h"
#import "THMainView.h"

@interface THMainViewController () <UIScrollViewDelegate, UIKeyInput, THThoughtViewDelegate>

@property (nonatomic, strong, readonly) THMainView *mainView;

@property (nonatomic, strong, readonly) id <THThoughtContext> thoughtContext;

@property (nonatomic, strong, readwrite) id <THThought> thought;

@end

@implementation THMainViewController

@synthesize mainView = _mainView, thoughtContext = _thoughtContext, thought = _thought;

-(instancetype)initWithThoughtContext:(id<THThoughtContext>)thoughtContext
{
    if(self = [super init]) {
        _thoughtContext = thoughtContext;
    }
    
    return self;
}

-(void)loadView
{
    self.view = self.mainView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.thought = [self.thoughtContext firstThought];
    
    self.mainView.emptyScrollView.delegate = self;
    self.mainView.thoughtView.delegate = self;
    
    
    [self becomeFirstResponder];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)insertText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        return;
    }
    
    self.mainView.thoughtView.thoughtText = text;
    [self.mainView.thoughtView becomeFirstResponder];
}

-(void)deleteBackward
{
}

-(BOOL)hasText
{
    return NO;
}

-(void)setThought:(id<THThought>)thought
{
    //NSLog(@"%@",thought);
    _thought = thought;
    
    self.mainView.thoughtView.thoughtText = _thought.text;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    
    if(contentOffset.x >= pageWidth*2) {
        contentOffset.x -= pageWidth;
        scrollView.contentOffset = contentOffset;
        
        if([self.mainView.thoughtView isFirstResponder]) {
            return;
        }
        
        self.thought = self.thought.nextThought;
        
    }
    
    if(contentOffset.x <= 0) {
        contentOffset.x += pageWidth;
        scrollView.contentOffset = contentOffset;
        
        if([self.mainView.thoughtView isFirstResponder]) {
            return;
        }
        
        self.thought = self.thought.previousThought;
        //Chinese    app ideas
    }
    
}

-(BOOL)thoughtViewShouldEndEditing:(THThoughtView *)thoughtView
{
    THThoughtSpecification *newThoughtSpecification = [THThoughtSpecification new];
    newThoughtSpecification.text = thoughtView.thoughtText;
    
    if(self.thought) {
        self.thought = [self.thought createThoughtAfterThisWithSpecification:newThoughtSpecification];
    }else {
        self.thought = [self.thoughtContext createThoughtWithSpecification:newThoughtSpecification];
    }
    
    return YES;
}

-(THMainView *)mainView
{
    if(!_mainView) {
        _mainView = [[THMainView alloc] initWithFrame:CGRectZero];
    }
    
    return _mainView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
