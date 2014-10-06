//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerTimeService.h"

@implementation DinnerTimeService {

}

- (instancetype)init {
  self = [super init];
  if (self) {
    NSURL *URL = [NSURL URLWithString:@"https://192.168.1.126"];
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    self.sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    self.sessionManager.securityPolicy.allowInvalidCertificates = YES;
  }

  return self;
}


- (void)loginWithToken:(NSString *)token withCallback:(void (^)(NSString *sessionId))callback {
  [self.sessionManager POST:@"/login" parameters:@{@"token": token} success:^(NSURLSessionDataTask *operation, id responseObject) {
    callback(responseObject[@"session_id"]);
  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSLog(@"error = %@", error);
  }];
}

- (void)getDinners:(void (^)(NSArray *))callback {
  [self.sessionManager GET:@"/dinners" parameters:nil success:nil failure:nil];
}

@end