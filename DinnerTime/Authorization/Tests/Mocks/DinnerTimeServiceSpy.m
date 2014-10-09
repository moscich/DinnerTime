//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerTimeServiceSpy.h"


@implementation DinnerTimeServiceSpy {

}

- (void)loginWithToken:(NSString *)token withCallback:(void (^)(NSString *sessionId))callback {
  self.token = token;
  callback(@"sessionKey");
}

- (void)getDinners:(void (^)(NSArray *))callback {
  self.getDinnersCalled = YES;
}

@end