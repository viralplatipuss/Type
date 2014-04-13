//
//  TYUserDefaultsStringPersistor.m
//  Type
//
//  Created by Dom Chapman on 4/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "TYUserDefaultsStringPersistor.h"

static NSString * const kDefaultKey = @"key";

@interface TYUserDefaultsStringPersistor()

@property (nonatomic, copy, readonly) NSString *key;

@property (nonatomic, weak, readonly) NSUserDefaults *userDefaults;

@end

@implementation TYUserDefaultsStringPersistor


#pragma mark - Init

-(instancetype)init
{
    return [self initWithKey:nil];
}

-(instancetype)initWithKey:(NSString *)key
{
    self = [super init];
    if(self) {
        
        if(!key || !key.length) {
            key = kDefaultKey;
        }
        
        _key = [key copy];
        
    }
    
    return self;
}


#pragma mark - Public Properties

-(NSString *)string
{
    return [self.userDefaults objectForKey:self.key];
}

-(void)setString:(NSString *)string
{
    [self.userDefaults setObject:string forKey:self.key];
    [self.userDefaults synchronize];
}


#pragma mark - Private Properties

-(NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

@end
