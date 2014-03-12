//
//  THThoughtsViewController.m
//  Thoughts
//
//  Created by Dom Chapman on 3/12/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THMainViewController.h"
#import "THMainView.h"

@interface THMainViewController () <UIScrollViewDelegate, UIKeyInput>

@property (nonatomic, strong, readonly) THMainView *mainView;

@property (nonatomic, strong, readonly) id <THThoughtsProvider> thoughtsProvider;

@property (nonatomic, assign, readwrite) NSUInteger thoughtIndex;

@end

@implementation THMainViewController

@synthesize mainView = _mainView, thoughtsProvider = _thoughtsProvider, thoughtIndex = _thoughtIndex;

-(instancetype)initWithThoughtsProvider:(id<THThoughtsProvider>)thoughtsProvider
{
    if(self = [super init]) {
        _thoughtsProvider = thoughtsProvider;
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
    
    self.mainView.emptyScrollView.delegate = self;
    
    [self updateThought];
    
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

-(void)updateThought
{
    NSString *thought = [self.thoughtsProvider thoughtForUid:self.thoughtIndex];
    
    self.mainView.thoughtView.thoughtText = thought;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    
    if(contentOffset.x >= pageWidth) {
        contentOffset.x -= pageWidth;
        scrollView.contentOffset = contentOffset;
        
        if([self.mainView.thoughtView isFirstResponder]) {
            return;
        }
        
        self.thoughtIndex ++;
        if(self.thoughtIndex >= self.thoughtsProvider.totalThoughts) {
            self.thoughtIndex = 0;
        }
        
        [self updateThought];
        
    }
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
