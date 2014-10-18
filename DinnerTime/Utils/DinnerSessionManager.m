//
// Created by Marek Moscichowski on 10/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerSessionManager.h"

@implementation DinnerSessionManager {

}

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)sessionManager {
  self = [super init];
  if (self) {
    self.sessionManager = sessionManager;
  }

  return self;
}

- (void)GET:(NSString *)string parameters:(NSDictionary *)parameters success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure {
  [self.sessionManager.requestSerializer setValue:self.sessionId forHTTPHeaderField:@"session_id"];
  NSLog(@"self.sessionId = %@", self.sessionId);
  [self.sessionManager GET:string parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    [self sendCallback:success withResponseObject:responseObject];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"error = %@", error);
    failure(error);
  }];
}

- (void)POST:(NSString *)string parameters:(NSDictionary *)parameters success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure {
  [self.sessionManager.requestSerializer setValue:self.sessionId forHTTPHeaderField:@"session_id"];
  [self.sessionManager POST:string parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    [self sendCallback:success withResponseObject:responseObject];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {

  }];
}

- (void)sendCallback:(void (^)(NSString *))success withResponseObject:(id)responseObject {
  NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
  success(jsonString);
}

@end