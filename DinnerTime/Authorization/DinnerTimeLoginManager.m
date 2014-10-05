//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerTimeLoginManager.h"
#import "DinnerTimeService.h"


@implementation DinnerTimeLoginManager {

}

- (void)signInWithToken:(NSString *)token {
  [self.dinnerTimeService loginWithToken:token withCallback:^(NSString *sessionId) {
    [self.delegate dinnerTimeLoginManagerLoginSuccessfully];
  }];
}

@end