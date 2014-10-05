//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerTimeLoginManager.h"
#import "DinnerTimeService.h"
#import "UICKeyChainStore.h"


@implementation DinnerTimeLoginManager {

}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.dinnerTimeService = [DinnerTimeService new];
  }

  return self;
}

- (void)signInWithToken:(NSString *)token {
  [self.dinnerTimeService loginWithToken:token withCallback:^(NSString *sessionId) {
    [UICKeyChainStore setString:sessionId forKey:@"sessionID"];
    [self.delegate dinnerTimeLoginManagerLoginSuccessfully];
  }];
}

@end