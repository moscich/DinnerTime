//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerTimeService.h"
#import "UICKeyChainStore.h"

@implementation DinnerTimeService {

}

- (instancetype)init {
  self = [super init];
  if (self) {
    NSURL *URL = [NSURL URLWithString:@"https://192.168.1.126"];
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    self.sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    self.sessionManager.securityPolicy.allowInvalidCertificates = YES;
    self.session = [UICKeyChainStore stringForKey:@"session_id"];
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

- (void)getDinners:(void (^)(NSArray *))callback failure:(void (^)(DinnerServiceResultType))failure {
  if(self.session == nil){
    failure(DinnerServiceResult_Unauthorized);
    return;
  }
  [self.sessionManager.requestSerializer setValue:self.session forHTTPHeaderField:@"session_id"];
  [self.sessionManager GET:@"/dinners" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    callback(nil);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    if(error.code == 401)
      failure(DinnerServiceResult_Unauthorized);
  }];
}

@end