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
    
    XCTAssertEqualObjects(thought.text, thoughtSpec.text, @"thought text incorrect");
    
    XCTAssertEqual(thought.thoughtContext, self.thoughtContext, @"thought's context reference incorrect.");
    
    XCTAssertTrue(thought.previousThought == thought && thought.nextThought == thought, @"thought not cyclically referencing self.");
    
    XCTAssertNotNil([thought uniqueToken], @"thought does not have unique token");
}

-(void)testRemoveThoughtFromContext
{
    TYCoreDataThought *thought = [self addThoughtWithText:@"test"];
    
    [self.thoughtContext removeThought:thought];
    
    XCTAssertNil([self.thoughtContext anyThought], @"thought context not empty after removing only thought");
}

-(void)testDeleteThought
{
    TYCoreDataThought *thought = [self addThoughtWithText:@"test"];
    
    [thought deleteThought];
    
    XCTAssertNil([self.thoughtContext anyThought], @"thought context not empty after removing only thought");
}

-(void)testAddThoughtAfterThought
{
    TYCoreDataThought *thought = [self addThoughtWithText:@"one"];
    
    TYThoughtSpecification *spec = [TYThoughtSpecification new];
    spec.text = @"two";
    
    TYCoreDataThought *thought2 = [thought createThoughtAfterThisWithSpecification:spec];
    
    XCTAssertNotNil(thought2, @"failed to add thought after a thought");
    
    XCTAssertEqual(thought2.thoughtContext, self.thoughtContext, @"incorrect thought context set");
    
    XCTAssertTrue(thought.nextThought == thought2 &&
                  thought.previousThought == thought2 &&
                  thought2.previousThought == thought &&
                  thought2.nextThought == thought, @"Thought relationships not created correctly.");
    
}

-(void)testAddThreeThoughtsThenRemoveMiddleOne
{
    TYCoreDataThought *thought1 = [self addThoughtWithText:@"one"];
    
    TYThoughtSpecification *spec = [TYThoughtSpecification new];
    spec.text = @"two";
    
    TYCoreDataThought *thought2 = [thought1 createThoughtAfterThisWithSpecification:spec];
    
    spec.text = @"three";
    
    TYCoreDataThought *thought3 = [thought2 createThoughtAfterThisWithSpecification:spec];
    
    XCTAssertEqual(thought2.nextThought, thought3, @"Incorrect next thought when creating thought after thought.");
    
    XCTAssertEqual(thought3.nextThought, thought1, @"Thought references aren't cyclical.");
    
    [thought2 deleteThought];
    
    XCTAssertEqual(thought1.nextThought, thought3, @"Previous thought of deleted thought's next reference incorrect.");
    XCTAssertEqual(thought1.previousThought, thought3, @"Previous thought of deleted thought's previous reference incorrect.");
    
    XCTAssertEqual(thought3.previousThought, thought1, @"Next thought of deleted thought's previous reference incorrect.");
    XCTAssertEqual(thought3.nextThought, thought1, @"Next thought of deleted thought's next reference incorrect.");
}

-(void)testRetrieveThoughtByToken
{
    TYCoreDataThought *thought = [self addThoughtWithText:@"test"];
    
    NSString *token = [thought uniqueToken];
    
    TYCoreDataThought *retrievedThought = [self.thoughtContext thoughtForUnqiueToken:token];
    
    XCTAssertEqual(thought, retrievedThought, @"Incorrect thought retrieved for token.");
    
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