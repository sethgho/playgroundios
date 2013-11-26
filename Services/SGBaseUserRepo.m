//
//  SGBaseUserRepo.m
//  Playground
//
//  Created by Seth on 11/26/13.
//  Copyright (c) 2013 Seth Gholson. All rights reserved.
//

#import "SGBaseUserRepo.h"

@implementation SGBaseUserRepo


-(void)validateResponse:(NSURLResponse*)response error:(NSError**)error {
	if(*error) {
		return;
	}
	
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
	switch (httpResponse.statusCode) {
		case 200:
			return;
		case 201:
			return;
		case 404:
			[userInfo setObject:@"Record not found." forKey:NSLocalizedDescriptionKey];
			*error = [NSError errorWithDomain:SGErrorServiceDomain code:SGServiceErrorNotFound userInfo:userInfo];
			break;
		default:
			break;
	}
	
	return;
}

@end
