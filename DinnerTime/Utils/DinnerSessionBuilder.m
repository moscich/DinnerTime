//
// Created by Marek Moscichowski on 11/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerSessionBuilder.h"
#import "DinnerSessionManager.h"


@implementation DinnerSessionBuilder {

}
- (DinnerSessionManager *)constructSessionManager {
  AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.1.131:3001"]];
  sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//  sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//  sessionManager.securityPolicy.allowInvalidCertificates = YES;
  DinnerSessionManager *dinnerSessionManager = [[DinnerSessionManager alloc] initWithSessionManager:sessionManager];

  return dinnerSessionManager;
}
@end