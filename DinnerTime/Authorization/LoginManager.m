//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "LoginManager.h"
#import "GoogleSignInManager.h"
#import "DinnerTimeLoginManager.h"
#import "LoginManagerDelegateSpy.h"


@implementation LoginManager {

}
- (id)initWithGoogleSignInManager:(GoogleSignInManager *)googleSignInManager withDinnerTimeLoginManager:(DinnerTimeLoginManager *)loginManager {
  self = [super init];
  if(self){
    self.googleManger = googleSignInManager;
    self.dinnerTimeLoginManager = loginManager;
    self.googleManger.delegate = self;
    self.dinnerTimeLoginManager.delegate = self;
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
  [self.dinnerTimeLoginManager signInWithToken:token];
}

- (void)dinnerTimeLoginManagerLoginSuccessfully {
  [self.delegate loginManagerLoginSuccessful];
}

@end