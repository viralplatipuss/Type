//
//  NSString+CharactersAndIndexes.m
//  Type
//
//  Created by Dom Chapman on 3/22/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "NSString+CharactersAndIndexes.h"


NSString *const kCharactersAndIndexesDictionaryKeyForCharacter = @"character";

NSString *const kCharactersAndIndexesDictionaryKeyForIndex = @"index";


@implementation NSString (CharactersAndIndexes)

-(NSArray *)charactersAndIndexes
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSUInteger i=0; i<[self length]; i++) {
        
        NSDictionary *dictionary = @{kCharactersAndIndexesDictionaryKeyForCharacter: [self substringWithRange:NSMakeRange(i, 1)],
                                     kCharactersAndIndexesDictionaryKeyForIndex: @(i)};
        [array addObject:dictionary];
    }
    
    return array;
}

@end
