//
//  THTestingViewController.m
//  Thoughts
//
//  Created by Dom Chapman on 3/16/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "THTestingViewController.h"

#import "TYIndividualCharacterLabelsView.h"

#import "MTRandom.h"

@interface THTestingViewController ()

@property (nonatomic, strong, readwrite) TYIndividualCharacterLabelsView *sctv;

@end

@implementation THTestingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blueColor];
    
    self.sctv = [TYIndividualCharacterLabelsView new];
    
    NSString *testString = @"Tom. This is a test.\nNew line.\nThis matches UILabel.";
    
    self.sctv.text = testString;
    self.sctv.font = [UIFont fontWithName:@"Raleway-Light" size:22];
    
    self.sctv.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.sctv];
    
    self.sctv.center = CGPointMake(150, 200);
    
    UILabel *test = [self.sctv labelForCharacterAtIndex:34];
    //test.backgroundColor = [UIColor redColor];
    
    test = [self.sctv labelForCharacterAtIndex:12];
    //test.backgroundColor = [UIColor yellowColor];
    
    UILabel *label = [UILabel new];
    label.font = self.sctv.font;
    
    label.text = testString;
    label.numberOfLines = 0;
    
    [label sizeToFit];
    
    label.backgroundColor = [UIColor yellowColor];

    
    [UIView animateWithDuration:8 delay:2 options:0 animations:^{
        
        label.alpha = 0;
        
        
    } completion:nil];
    
    [self.view addSubview:label];
    
    label.center = CGPointMake(150, 200);

    
    NSLog(@"%@",NSStringFromCGRect(label.frame));
    
    NSLog(@"%@",NSStringFromCGRect(self.sctv.frame));
    
    /*
     
     //Silly animation test
     
    test = [self.sctv labelForCharacterAtIndex:10];
    test.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -24, -10);
    [UIView animateWithDuration:5 delay:1 options:0 animations:^{
        test.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    test = [self.sctv labelForCharacterAtIndex:15];
    test.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -14, -50);
    [UIView animateWithDuration:5 delay:1 options:0 animations:^{
        test.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    test = [self.sctv labelForCharacterAtIndex:22];
    test.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -33, 10);
    [UIView animateWithDuration:5 delay:1 options:0 animations:^{
        test.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    test = [self.sctv labelForCharacterAtIndex:26];
    test.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, -13);
    [UIView animateWithDuration:5 delay:1 options:0 animations:^{
        test.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    */
    
    MTRandom *random = [[MTRandom alloc] initWithSeed:10];
    
    NSLog(@"%i", [random randomUInt32From:0 to:10]);
    
    NSLog(@"%i", [random randomUInt32From:0 to:10]);
    
    NSLog(@"%i", [random randomUInt32From:0 to:10]);
    
    NSLog(@"%i", [random randomUInt32From:0 to:10]);
    
    NSLog(@"%i", [random randomUInt32From:0 to:10]);
    
}

// RAND_MAX assumed to be 32767.
static unsigned long int next = 1;
void lilsrand(unsigned int seed) { next = seed; }
int lilrand(void) {
    next = next * 1103515245 + 12345;
    return (unsigned int)(next/65536) % 32768;
}

@end
