//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>
#import "DinnerTimeService.h"
#import "AFHTTPRequestOperation.h"


@implementation DinnerTimeService {

}

- (instancetype)init {
  self = [super init];
  if (self) {
    NSURL *URL = [NSURL URLWithString:@"https://192.168.1.126"];
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    manager.securityPolicy.allowInvalidCertificates = YES;
  }

  return self;
}


- (void)loginWithToken:(NSString *)token withCallback:(void (^)(NSString *sessionId))callback {
  [self.sessionManager GET:@"/login" parameters:@{@"token": token} success:^(NSURLSessionDataTask *operation, id responseObject) {
    callback(responseObject[@"session_id"]);
  } failure:nil];
}
@end