//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "LoginManager.h"
#import "GoogleSignInManager.h"
#import "DinnerTimeLoginManager.h"


@implementation LoginManager {

}
- (void)signIn {
  [self.googleManger signIn];
}

- (id)initWithGoogleSignInManager:(GoogleSignInManager *)googleSignInManager withDinnerTimeLoginManager:(DinnerTimeLoginManager *)loginManager {
  self = [super init];
  if(self){
    self.googleManger = googleSignInManager;
    self.dinnerTimeLoginManager = loginManager;
  }
  return self;
}

- (void)googleSignInManagerAuthenticatedInGoogleWithToken:(NSString *)token {
  [self.dinnerTimeLoginManager signInWithToken:token];
}

@end