//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController {

}

- (instancetype)init {
  self = [super init];
  if(self){
    self.loginManager = [[LoginManager alloc] initWithGoogleSignInManager:[GoogleSignInManager new] withDinnerTimeLoginManager:[DinnerTimeLoginManager new]];
    self.loginManager.delegate = self;
  }
  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if(self){

  }
  return self;
}

- (void)loginManagerLoginSuccessful {

}

- (IBAction)loginButtonTapped {
  [self.loginManager signIn];
}

@end