//
//  SGPlaygroundUser.m
//  Playground
//
//  Created by Seth on 11/25/13.
//  Copyright (c) 2013 Seth Gholson. All rights reserved.
//

#import "SGPlaygroundUser.h"

@implementation SGPlaygroundUser

-(NSString*)fullName {
	return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
