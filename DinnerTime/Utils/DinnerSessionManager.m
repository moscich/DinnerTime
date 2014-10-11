//
// Created by Marek Moscichowski on 10/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerSessionManager.h"
#import "HttpSessionManagerSpy.h"


@implementation DinnerSessionManager {

}

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)sessionManager {
  self = [super init];
  if (self) {
    self.sessionManager = sessionManager;
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
  }

  return self;
}

- (void)GET:(NSString *)string parameters:(NSDictionary *)parameters success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure {
  [self.sessionManager GET:string parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    success(jsonString);
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(error);
  }];
}
@end