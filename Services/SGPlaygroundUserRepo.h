//
//  SGPlaygroundUserRepo.h
//  Playground
//
//  Created by Seth on 11/25/13.
//  Copyright (c) 2013 Seth Gholson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGPlaygroundUser.h"

#define PLAYGROUND_PRODUCTION_URL @"http://playground-sethgho.rhcloud.com/api/"

typedef void(^AllUsersBlock)(NSArray* users, NSError *error);
typedef void(^UserBlock)(SGPlaygroundUser* user, NSError *error);

@interface SGPlaygroundUserRepo : NSObject

- (id)initWithBaseUrl:(NSString*)baseUrl;
- (void)allUsers:(AllUsersBlock)block;
- (void)user:(NSNumber*)userId block:(UserBlock)block;

+ (SGPlaygroundUser*)userFromJSON:(NSDictionary*)json;

@end
