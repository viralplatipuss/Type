//
//  NSString+MatchedCharacterIndexes.h
//  Type
//
//  Created by Dom Chapman on 3/22/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MatchedCharacterIndexes)

/*
 Finds matching characters between this and the given string. Stores matching character's index with a key of its own character's index.
 
 Each chararcter is only matched once.
 
 Dispersed matching will find matches spread-out over the strings, rather than iterating from start to finish. This is safely repeatable
 with the same result if the strings are kept the same.
 
 */
-(NSDictionary *)indexesOfMatchedCharactersWithString:(NSString *)matchString dispersedMatching:(BOOL)dispersed;

@end
