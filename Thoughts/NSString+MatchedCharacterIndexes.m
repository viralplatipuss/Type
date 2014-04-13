//
//  NSString+MatchedCharacterIndexes.m
//  Type
//
//  Created by Dom Chapman on 3/22/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import "NSString+MatchedCharacterIndexes.h"
#import "NSString+CharactersAndIndexes.h"
#import "NSMutableArray+pseudoRandomShuffle.h"

NSString *const kMatchedCharacterIndexesDictionaryKeyForIndex = @"index";

NSString *const kMatchedCharacterIndexesDictionaryKeyForMatchedIndex = @"matchedIndex";

@implementation NSString (MatchedCharacterIndexes)

-(NSDictionary *)indexesOfMatchedCharactersWithString:(NSString *)matchString dispersedMatching:(BOOL)dispersed
{
    NSMutableDictionary *indexes = [NSMutableDictionary dictionary];
    
    NSMutableArray *myCharactersAndIndexes = [self charactersAndIndexes];
    NSMutableArray *matchCharacterAndIndexes = [matchString charactersAndIndexes];
    
    if(dispersed) {
        [myCharactersAndIndexes pseudoRandomShuffleWithSeed:(u_int32_t)[self hash]];
        [matchCharacterAndIndexes pseudoRandomShuffleWithSeed:(u_int32_t)[matchString hash]];
    }
    
    
    for (NSDictionary *myCharacterDictionary in myCharactersAndIndexes) {
        
        NSString *myCharacter = myCharacterDictionary[kCharactersAndIndexesDictionaryKeyForCharacter];
        
        for (NSUInteger i=0; i<[matchCharacterAndIndexes count]; i++) {
            
            NSDictionary *matchCharacterDictionary = matchCharacterAndIndexes[i];
            NSString *matchCharacter = matchCharacterDictionary[kCharactersAndIndexesDictionaryKeyForCharacter];
            
            //Check characters match
            if([myCharacter isEqualToString:matchCharacter]) {
                
                //Get indexes for matching characters
                NSNumber *myCharacterIndex = myCharacterDictionary[kCharactersAndIndexesDictionaryKeyForIndex];
                NSNumber *matchCharacterIndex = matchCharacterDictionary[kCharactersAndIndexesDictionaryKeyForIndex];
                
                //Add indexes
                indexes[myCharacterIndex] = matchCharacterIndex;
                
                //Remove matched character from match array, so it can't be re-matched.
                [matchCharacterAndIndexes removeObjectAtIndex:i];
                
                break;
            }
        }
    }
    
    return [indexes copy];
}

@end
