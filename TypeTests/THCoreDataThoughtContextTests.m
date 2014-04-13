//
//  THCoreDataThoughtContextTests.m
//  Thoughts
//
//  Created by Dom Chapman on 3/15/14.
//  Copyright (c) 2014 Dom Chapman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TYCoreDataThoughtContext.h"

@interface THCoreDataThoughtContextTests : XCTestCase

@property (nonatomic, strong, readwrite) TYCoreDataThoughtContext *context;

@property (nonatomic, strong, readwrite) NSMutableArray *testThoughts;

@end

@implementation THCoreDataThoughtContextTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.testThoughts = [NSMutableArray array];
    
    self.context = [[TYCoreDataThoughtContext alloc] initWithPersistentStoreType:NSInMemoryStoreType URL:nil];
    XCTAssertNotNil(self.context, @"Cannot create core data thought context.");
    
    //Add 3 test thoughts into context for testing.
    
    for (NSUInteger i=0; i<3; i++) {
        
        TYThoughtSpecification *specification = [TYThoughtSpecification new];
        
        XCTAssertNotNil(specification, @"Cannot create thought specification.");
        
        NSString *testThoughtText = [NSString stringWithFormat:@"Test Thought %lu",i];
        
        specification.text = testThoughtText;
        
        XCTAssertEqual(specification.text, testThoughtText, @"Failed to set text on thought specification.");
        
        id <TYThought> thought = [self.context createThoughtWithSpecification:specification];
        
        XCTAssertNotNil(thought, @"Failed to return created thought.");
        
        [self.testThoughts addObject:thought];
        
    }
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    
    
}

#pragma mark - Helpers

- (void)addThought
{
    
}

#pragma mark - Tests

-(void)testAnyThought
{
    id <TYThought> anyThought = [self.context anyThought];
    
    XCTAssertNotNil(anyThought, @"Failed to return any thought.");
    
    XCTAssertTrue([self.testThoughts containsObject:anyThought], @"Invalid thought returned.");
    
}


@end
