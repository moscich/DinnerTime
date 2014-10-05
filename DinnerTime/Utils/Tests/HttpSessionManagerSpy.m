//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "HttpSessionManagerSpy.h"


@implementation HttpSessionManagerSpy {

}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  self.parameters = parameters;
  self.calledAddress = URLString;
  success(nil, @{@"session_id":@"testSessionID"});
  return nil;
}

@end