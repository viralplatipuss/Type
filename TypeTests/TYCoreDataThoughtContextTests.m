//
//  TYCoreDataThoughtContextTests.m
//  Type
//
//  Created by Dom Chapman on 4/13/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TYCoreDataThoughtContext.h"

@interface TYCoreDataThoughtContextTests : XCTestCase

@property (nonatomic, strong, readwrite) TYCoreDataThoughtContext *thoughtContext;

@end

@implementation TYCoreDataThoughtContextTests

- (void)setUp
{
    [super setUp];
    
    self.thoughtContext = [[TYCoreDataThoughtContext alloc] initWithPersistentStoreType:NSInMemoryStoreType URL:nil];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testAddThought
{
    TYThoughtSpecification *thoughtSpec = [TYThoughtSpecification new];
    thoughtSpec.text = @"test thought";
  
    TYCoreDataThought *thought = [self.thoughtContext createThoughtWithSpecification:thoughtSpec];
    
    XCTAssertNotNil(thought, @"thought not added");
    
    XCTAssertTrue([thought.text isEqualToString:thoughtSpec.text], @"thought text incorrect");
    
    XCTAssertTrue(thought.thoughtContext == self.thoughtContext, @"thought's context reference incorrect.");
    
    XCTAssertTrue(thought.previousThought == thought && thought.nextThought == thought, @"thought not cyclically referencing self.");
    
    XCTAssertNotNil([thought uniqueToken], @"thought does not have unique token");
}

-(void)testRemoveThought
{
    TYCoreDataThought *thought = [self addThoughtWithText:@"test"];
    
    [self.thoughtContext removeThought:thought];
    
    XCTAssertNil([self.thoughtContext anyThought], @"thought context not empty after removing only thought");
    
}

-(void)testAddThoughtAfterThought
{
    TYCoreDataThought *thought = [self addThoughtWithText:@"one"];
    
    TYThoughtSpecification *spec = [TYThoughtSpecification new];
    spec.text = @"two";
    
    TYCoreDataThought *thought2 = [thought createThoughtAfterThisWithSpecification:spec];
    
    XCTAssertNotNil(thought2, @"failed to add thought after a thought");
    
    XCTAssertTrue(thought2.thoughtContext == self.thoughtContext, @"incorrect thought context set");
    
    XCTAssertTrue(thought.nextThought == thought2 &&
                  thought.previousThought == thought2 &&
                  thought2.previousThought == thought &&
                  thought2.nextThought == thought, @"Thought relationships not created correctly.");
    
}


#pragma mark - Private Helpers

-(TYCoreDataThought *)addThoughtWithText:(NSString *)text
{
    TYThoughtSpecification *thoughtSpec = [TYThoughtSpecification new];
    thoughtSpec.text = text;
    
    TYCoreDataThought *thought = [self.thoughtContext createThoughtWithSpecification:thoughtSpec];
    
    return thought;
}

@end