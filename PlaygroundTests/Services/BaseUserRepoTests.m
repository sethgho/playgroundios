//
//  BaseUserRepoTests.m
//  Playground
//
//  Created by Seth on 11/26/13.
//  Copyright (c) 2013 Seth Gholson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SGBaseUserRepo.h"

@interface BaseUserRepoTests : XCTestCase

@end

@implementation BaseUserRepoTests

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

- (void)testResponseValidationSuccess
{
	NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"www.google.com"]
														  statusCode:200
														 HTTPVersion:@"1.1"
														headerFields:nil];
	SGBaseUserRepo *repo = [[SGBaseUserRepo alloc] init];
	NSError *error = nil;
	[repo validateResponse:response error:&error];
	XCTAssertNil(error, @"a 200 response should return no error.");
}

- (void)testResponseValidationNotFound
{
	NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"www.google.com"]
															  statusCode:404
															 HTTPVersion:@"HTTP/1.1"
															headerFields:nil];
	SGBaseUserRepo *repo = [[SGBaseUserRepo alloc] init];
	NSError *error = nil;
	[repo validateResponse:response error:&error];
	XCTAssertNotNil(error, @"a 404 response should return an error.");
	XCTAssertEqualObjects([error domain], SGErrorServiceDomain, @"Error domain was incorrect");
	XCTAssertEqual([error code], SGServiceErrorNotFound, @"A 404 should return a Not Found error.");
}

@end
