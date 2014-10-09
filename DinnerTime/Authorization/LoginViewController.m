//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "LoginViewController.h"
#import "DinnerListViewController.h"
#import "DinnerTimeService.h"


@implementation LoginViewController {

}

- (instancetype)init {
  self = [super init];
  if(self){
    self.loginManager = [[LoginManager alloc] initWithGoogleSignInManager:[GoogleSignInManager new] withDinnerTimeService:[DinnerTimeService new]];
    self.loginManager.delegate = self;
  }
  return self;
}

- (void)loginManagerLoginSuccessful {
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  [self.navigationController pushViewController:dinnerListViewController animated:YES];
}

- (IBAction)loginButtonTapped {
  [self.loginManager signIn];
}

@end