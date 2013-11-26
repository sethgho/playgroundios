//
//  SGBaseUserRepo.h
//  Playground
//
//  Created by Seth on 11/26/13.
//  Copyright (c) 2013 Seth Gholson. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SGErrorServiceDomain	@"SGPlaygroundErrorDomain"

typedef NS_ENUM(NSInteger,SGServiceErrorType) {
	SGServiceErrorNotFound = 404,
	SGServiceErrorUnknown = 999
};

@interface SGBaseUserRepo : NSObject

-(void)validateResponse:(NSURLResponse*)response error:(NSError**)error;

@end
