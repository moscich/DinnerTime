//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "LoginManager.h"
#import "GoogleSignInManager.h"


@implementation LoginManager {

}
- (void)signIn {
  [self.googleManger signIn];
}

- (id)initWithGoogleSignInManager:(GoogleSignInManager *)googleManager {
  self = [super init];
  if(self){
    self.googleManger = googleManager;
  }
  return self;
}

@end