//
//  TYMainViewController.m
//  Type
//
//  Created by Dom Chapman on 3/17/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYMainViewController.h"
#import "TYMainView.h"
#import "NSString+WordWrappedLineBreaks.h"



static const NSUInteger kCharacterLimit = 60;

@interface TYMainViewController () <UITextViewDelegate>

@property (nonatomic, strong, readonly) TYMainView *mainView;

@property (nonatomic, strong, readwrite) UILabel *label;

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
    
    self.mainView.textView.delegate = self;
    [self.mainView.textView becomeFirstResponder];
    
    self.label = [UILabel new];
    
     [self.mainView.headerView addSubview:self.label];
    
    
}

-(TYMainView *)mainView
{
    if(!_mainView) {
        _mainView = [TYMainView new];
    }
    
    return _mainView;
}

#pragma mark - TextView Delegate Methods

-(void)textViewDidChange:(UITextView *)textView
{
    [self resetTextIfJustEmptySpace];
    
    //Show/Hide textView
    if(self.mainView.textView.text.length == 0) {
        self.mainView.textView.hidden = YES;
    }else {
        self.mainView.textView.hidden = NO;
    }
    
    [self trimTextToFitCharacterLimit];
    
    [self sizedToFitLabelMatchingUITextView:self.mainView.textView];

}

-(void)resetTextIfJustEmptySpace
{
    if([self stringIsJustWhiteSpace:self.mainView.textView.text]) {
        self.mainView.textView.text = @"";
    }
}

-(void)trimTextToFitCharacterLimit
{
    [self trimTextView:self.mainView.textView toFitCharacterLimit:kCharacterLimit keepCaratPosition:YES];
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


-(BOOL)stringIsJustWhiteSpace:(NSString *)string
{
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(!trimmedString.length) {
        return YES;
    }
    
    return NO;
}


-(UILabel *)sizedToFitLabelMatchingUITextView:(UITextView *)textView
{
    UILabel *label = self.label;
    
    label.font = textView.font;
    label.backgroundColor = [UIColor greenColor];
    label.numberOfLines = 0;
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.label.text = [NSString stringWithAttributedString:textView.attributedText withLineBreakWordWrappingForWidth:CGRectGetWidth(textView.frame) stripWhitespaceAtBeginningAndEndOflines:YES];
    
    NSLog(@"%@",self.label.text);
    
    CGRect frame = label.frame;
    frame.size = label.intrinsicContentSize;
    frame.origin = textView.frame.origin;
    label.frame = frame;
    
    textView.textContainer.lineFragmentPadding = 0;
    textView.textContainerInset = UIEdgeInsetsZero;
    
    /*
    label.font = textView.font;
    label.backgroundColor = [UIColor greenColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    label.text = @"Tommy boy is\n     opop";
    
    NSLog(@"%@",textView.text);
    
    [label sizeToFit];
    
   // label.frame = CGRectOffset(label.frame, 20, 40);
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft ;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
        textView.textContainer.lineFragmentPadding = 0;
    textView.textContainerInset = UIEdgeInsetsZero;
    
    CGRect frame = CGRectMake(CGRectGetMinX(textView.frame), CGRectGetMinY(textView.frame), 0, 0);
    frame.size = textView.intrinsicContentSize;

    
    label.frame = frame;
    
    //label.frame = textView.frame;
    
    NSLog(@"%@",NSStringFromCGSize(frame.size));
    
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = textView.font;
    
    label.backgroundColor = [UIColor greenColor];
    
    
    label.text = textView.text;
    
    //[label sizeToFit];
    
    label.hidden = YES;
    */
    return label;
}

@end
