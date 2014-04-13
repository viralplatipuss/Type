//
//  NSString+CharactersAndIndexes.h
//  Type
//
//  Created by Dom Chapman on 3/22/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const kCharactersAndIndexesDictionaryKeyForCharacter;

extern NSString *const kCharactersAndIndexesDictionaryKeyForIndex;


@interface NSString (CharactersAndIndexes)

/*
 Returns an array of dictionaries. Each dictionary contains the character and its index in the string.
 They can be accessed using the constants for dictionary keys.
 */
-(NSMutableArray *)charactersAndIndexes;

@end
