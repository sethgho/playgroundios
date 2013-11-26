//
//  PlaygroundUserRepoTests.m
//  Playground
//
//  Created by Seth on 11/25/13.
//  Copyright (c) 2013 Seth Gholson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SGPlaygroundUser.h"
#import "SGPlaygroundUserRepo.h"
#import <Nocilla.h>

static inline void hxRunInMainLoop(void(^block)(BOOL *done)) {
    __block BOOL done = NO;
    block(&done);
    while (!done) {
        [[NSRunLoop mainRunLoop] runUntilDate:
		 [NSDate dateWithTimeIntervalSinceNow:.1]];
    }
}

@interface PlaygroundUserRepoTests : XCTestCase

@end

@implementation PlaygroundUserRepoTests

- (void)setUp
{
    [super setUp];
	[[LSNocilla sharedInstance] start];
}

- (void)tearDown
{
	[[LSNocilla sharedInstance] stop];
    [super tearDown];
}

- (void)testJsonInflation
{
	NSString* rawJson = @"{\"lastName\": \"Doe\",\"firstName\": \"John\",\"gender\": \"male\",\"address\": \"123 Main Street\",\"city\": \"Blueberryville\",\"stateCode\": \"TX\",\"zipCode\": \"78729\"}";
	NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[rawJson dataUsingEncoding:NSUTF8StringEncoding]
									options:NSJSONReadingMutableLeaves
									  error:nil];
	SGPlaygroundUser *user = [SGPlaygroundUserRepo userFromJSON:jsonObject];
	
	XCTAssertEqualObjects(user.lastName, @"Doe", @"Last name was not read from JSON correctly.");
	XCTAssertEqualObjects(user.firstName, @"John", @"First name was not read from JSON correctly.");
	XCTAssertEqualObjects(user.address, @"123 Main Street", @"Address was not read from JSON correctly.");
	XCTAssertEqualObjects(user.city, @"Blueberryville", @"City was not read from JSON correctly.");
	XCTAssertEqualObjects(user.stateCode, @"TX", @"StateCode was not read from JSON correctly.");
	XCTAssertEqualObjects(user.zipCode, @"78729", @"ZipCode was not read from JSON correctly.");
}

- (void)testGetAllUsers {
	stubRequest(@"GET", @"http://playground-sethgho.rhcloud.com/api/user/all").
	andReturn(200).
	withBody(@"[{\"lastName\":\"Doe\",\"firstName\":\"John\",\"gender\":\"male\",\"address\":\"123MainStreet\",\"city\":\"Blueberryville\",\"stateCode\":\"TX\",\"zipCode\":\"78729\"},{\"lastName\":\"Doe\",\"firstName\":\"Jane\",\"gender\":\"female\",\"address\":\"123MainStreet\",\"city\":\"Blueberryville\",\"stateCode\":\"TX\",\"zipCode\":\"78729\"}]");

	SGPlaygroundUserRepo *repo = [SGPlaygroundUserRepo sharedInstance];
	hxRunInMainLoop(^(BOOL *done) {
		[repo allUsers:^(NSArray *users, NSError *error) {
			XCTAssertNotNil(users, @"User list response was empty.");
			XCTAssertEqual(users.count, (NSUInteger)2, @"Two users were not returned.");
			SGPlaygroundUser *user = [users firstObject];
			XCTAssertEqualObjects(user.firstName, @"John", @"First user was not John Doe.");
			*done = YES;
		}];
	});
}

- (void)testGetUser {
	stubRequest(@"GET", @"http://playground-sethgho.rhcloud.com/api/user/1").
	andReturn(200).
	withBody(@"{  \"lastName\": \"Doe\",  \"firstName\": \"John\",  \"gender\": \"male\",  \"address\": \"123 Main Street\",  \"city\": \"Blueberryville\",  \"stateCode\": \"TX\",  \"zipCode\": \"78729\"}");
	
	SGPlaygroundUserRepo *repo = [SGPlaygroundUserRepo sharedInstance];
	hxRunInMainLoop(^(BOOL *done) {
		[repo user:[NSNumber numberWithInteger:1] block:^(SGPlaygroundUser *user, NSError *error) {
			XCTAssertNotNil(user, @"User returned should not be nil");
			XCTAssertEqualObjects(@"John", user.firstName, @"User's first name is wrong.");
			XCTAssertEqualObjects(@"Doe", user.lastName, @"User's last name is wrong");
			*done = YES;
		}];
	});
}

- (void)testFailGetUser {
	stubRequest(@"GET", @"http://playground-sethgho.rhcloud.com/api/user/1").
	andReturn(404);
	
	SGPlaygroundUserRepo *repo = [SGPlaygroundUserRepo sharedInstance];
	hxRunInMainLoop(^(BOOL *done) {
		[repo user:[NSNumber numberWithInt:1] block:^(SGPlaygroundUser *user, NSError *error) {
			XCTAssertNotNil(error, @"404 should return an error.");
			*done = YES;
		}];
	});
}

- (void)testStubbing {
	stubRequest(@"GET", @"http://www.google.com").andReturn(404);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];

	hxRunInMainLoop(^(BOOL *done) {
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
			XCTAssertEqual(2, 2, @"not working.");
			XCTAssertEqual(404, httpResponse.statusCode, @"Did not receive 404");
			*done = YES;
		}];
	});
}

@end
