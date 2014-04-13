//
//  TYUserDefaultsStringPersistor.h
//  Type
//
//  Created by Dom Chapman on 4/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYStringPersistor.h"

@interface TYUserDefaultsStringPersistor : NSObject <TYStringPersistor>

-(instancetype)initWithKey:(NSString *)key;

@end
