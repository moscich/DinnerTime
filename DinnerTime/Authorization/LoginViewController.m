//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "LoginViewController.h"
#import "DinnerListViewController.h"
#import "DinnerTimeService.h"
#import "DinnerManager.h"
#import "DinnerServiceResultType.h"
#import "LoginView.h"
#import "DinnerSessionBuilder.h"


@implementation LoginViewController {

}

- (void)loginManagerLoginSuccessful {
  [self navigateToDinnerList];
}

- (id)initWithDinnerManager:(DinnerManager *)dinnerManager {
  self = [super init];
  if(self){
    self.dinnerManager = dinnerManager;
    DinnerTimeService *dinnerTimeService = dinnerManager.dinnerTimeService;
    self.loginManager = [[LoginManager alloc] initWithGoogleSignInManager:[GoogleSignInManager new] withDinnerTimeService:dinnerTimeService];
    self.loginManager.delegate = self;
  }
  return self;
}

- (void)navigateToDinnerList {
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  dinnerListViewController.dinnerManager = self.dinnerManager;
  dinnerListViewController.loginManager = self.loginManager;
  [self.navigationController pushViewController:dinnerListViewController animated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.dinnerManager getDinners:^(DinnerServiceResultType type) {
    if(type == DinnerServiceResult_Unauthorized){
      ((LoginView *)self.view).activityIndicator.hidden = YES;
      ((LoginView *)self.view).signInButton.hidden = NO;
    }else if(type == DinnerServiceResult_Success){
      [self navigateToDinnerList];
    }
  }];
}

- (IBAction)signIn {
  [self.loginManager signIn];
}

@end