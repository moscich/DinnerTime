//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "LoginManager.h"
#import "UICKeyChainStore.h"
#import "DinnerTimeServiceImpl.h"
#import "DinnerListViewController.h"


@implementation LoginManager {

}
- (id)initWithGoogleSignInManager:(GoogleSignInManager *)googleSignInManager withDinnerTimeService:(DinnerTimeServiceImpl *)dinnerTimeService {
  self = [super init];
  if(self){
    self.googleManger = googleSignInManager;
    self.googleManger.delegate = self;
    self.dinnerTimeService = dinnerTimeService;
  }
  return self;
}

- (instancetype)init {
  self = [super init];
  if (self) {

  }

  return self;
}

- (void)signIn {
  [self.googleManger signIn];
}

- (void)googleSignInManagerAuthenticatedInGoogleWithToken:(NSString *)token {
  [self.dinnerTimeService loginWithToken:token withCallback:^(NSString *sessionId) {
    [self.delegate loginManagerLoginSuccessful];
  }];
}


- (void)logout {
    [self.googleManger logout];
    [self.dinnerTimeService logout:^(DinnerServiceResultType type) {
    [self.logoutDelegate logoutManagerDidLogout];
  }];
}
@end