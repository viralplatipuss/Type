//
//  THTestingViewController.m
//  Thoughts
//
//  Created by Dom Chapman on 3/16/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THTestingViewController.h"

#import "TYIndividualCharacterLabelsView.h"

@interface THTestingViewController ()

@property (nonatomic, strong, readwrite) TYIndividualCharacterLabelsView *sctv;

@end

@implementation THTestingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sctv = [TYIndividualCharacterLabelsView new];
    
    NSString *testString = @"Hello. This is a test.\nNew line.\nThis matches UILabel.";
    
    self.sctv.text = testString;
    
    NSLog(@"%@",[testString substringWithRange:NSMakeRange(34, 1)]);
    
    [self.view addSubview:self.sctv];
    
    self.sctv.center = CGPointMake(150, 200);
    
    UILabel *test = [self.sctv labelForCharacterAtIndex:34];
    test.backgroundColor = [UIColor redColor];
    
    test = [self.sctv labelForCharacterAtIndex:12];
    test.backgroundColor = [UIColor yellowColor];
    
}

@end
