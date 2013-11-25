//
//  SGPlaygroundUser.h
//  Playground
//
//  Created by Seth on 11/25/13.
//  Copyright (c) 2013 Seth Gholson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGPlaygroundUser : NSObject

@property NSNumber* userId;
@property NSString* lastName;
@property NSString* firstName;
@property NSString* address;
@property NSString* city;
@property NSString* stateCode;
@property NSString *zipCode;

-(NSString*)fullName;

@end
