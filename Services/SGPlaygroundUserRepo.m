//
//  SGPlaygroundUserRepo.m
//  Playground
//
//  Created by Seth on 11/25/13.
//  Copyright (c) 2013 Seth Gholson. All rights reserved.
//

#import "SGPlaygroundUserRepo.h"

#define PATH_ALL_USERS  @"user/all"
#define PATH_USER(num) [NSString stringWithFormat:@"user/%d",num]

@implementation SGPlaygroundUserRepo {
	NSString *_baseUrl;
}

- (id)initWithBaseUrl:(NSString*)baseUrl {
	self = [super init];
	if(self) {
		_baseUrl = baseUrl;
	}
	return self;
}

+ (SGPlaygroundUserRepo*)sharedInstance {
    static SGPlaygroundUserRepo *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithBaseUrl:PLAYGROUND_PRODUCTION_URL];
    });
    return sharedInstance;
}

+ (SGPlaygroundUser*)userFromJSON:(NSDictionary*)json {
	SGPlaygroundUser *user = [[SGPlaygroundUser alloc] init];
	user.lastName = [json objectForKey:@"lastName"];
	user.firstName = [json objectForKey:@"firstName"];
	user.address = [json objectForKey:@"address"];
	user.city = [json objectForKey:@"city"];
	user.stateCode = [json objectForKey:@"stateCode"];
	user.zipCode = [json objectForKey:@"zipCode"];
	return user;
}

- (void)allUsers:(AllUsersBlock)block {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _baseUrl, PATH_ALL_USERS]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendAsynchronousRequest:request
									   queue:[NSOperationQueue mainQueue]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
							   [super validateResponse:response error:&connectionError];
							   if(connectionError) {
								   block(nil, connectionError);
							   } else {
								   NSArray *users = [self usersFromData:data];
								   block(users, nil);
							   }
	}];
}

- (void)user:(NSNumber*)userId block:(UserBlock)block {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _baseUrl, PATH_USER([userId intValue])]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendAsynchronousRequest:request
									   queue:[NSOperationQueue mainQueue]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
							   [super validateResponse:response error:&connectionError];
							   if(connectionError) {
								   block(nil, connectionError);
							   } else {
								   SGPlaygroundUser *user = [self userFromData:data];
								   block(user, nil);
							   }
						   }];
}

- (NSArray*) usersFromData:(NSData*)data {
	NSError *error;
	NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
	if(error){
		return nil;
	}
	
	NSMutableArray *users = [NSMutableArray array];
	[jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		SGPlaygroundUser *user = [SGPlaygroundUserRepo userFromJSON:obj];
		[users addObject:user];
	}];
	return users;
}

- (SGPlaygroundUser*)userFromData:(NSData*)data {
	NSError *error;
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
	if(error){
		return nil;
	}
	SGPlaygroundUser *user = [SGPlaygroundUserRepo userFromJSON:jsonDict];
	return user;
}

@end
