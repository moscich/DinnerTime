//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerTimeServiceSpy.h"


@implementation DinnerTimeServiceSpy {

}

- (id)initWithArray:(NSArray *)dinnerArray {
  self = [super init];
  if (self) {
    self.resultArray = dinnerArray;
  }

  return self;
}

- (void)logout:(void (^)(DinnerServiceResultType))callback {
  self.logoutCalled = YES;
  callback(DinnerServiceResult_Success);
}

- (void)loginWithToken:(NSString *)token withCallback:(void (^)(NSString *sessionId))callback {
  self.token = token;
  callback(@"sessionKey");
}

- (void)getDinners:(void (^)(NSArray *))callback failure:(void (^)(DinnerServiceResultType))failure {
  if(self.resultArray)
    callback(self.resultArray);
  else
    failure(DinnerServiceResult_Unauthorized);
  self.getDinnersCalled = YES;
}

@end