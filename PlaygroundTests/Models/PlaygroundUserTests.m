//
//  PlaygroundUserTests.m
//  Playground
//
//  Created by Seth on 11/25/13.
//  Copyright (c) 2013 Seth Gholson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SGPlaygroundUser.h"
@interface PlaygroundUserTests : XCTestCase

@end

@implementation PlaygroundUserTests {
	
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testFullName
{
	SGPlaygroundUser *user = [[SGPlaygroundUser alloc] init];
	user.lastName = @"Gholson";
	user.firstName = @"Seth";
	
	XCTAssertEqualObjects(@"Seth Gholson", user.fullName, @"User full name isn't correct.");
}

@end
