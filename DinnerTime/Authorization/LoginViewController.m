//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Typhoon/TyphoonComponentFactory.h>
#import "LoginViewController.h"
#import "DinnerListViewController.h"
#import "DinnerTimeServiceImpl.h"
#import "DinnerManager.h"
#import "DinnerServiceResultType.h"
#import "LoginView.h"
#import "DinnerSessionBuilder.h"


@implementation LoginViewController {

}

- (void)loginManagerLoginSuccessful {
  [self navigateToDinnerList];
}

- (instancetype)initWithDinnerManager:(DinnerManager *)dinnerManager loginManager:(LoginManager *)loginManager {
    self = [super init];
    if (self) {
        self.loginManager = loginManager;
        self.loginManager.delegate = self;
        self.dinnerManager = dinnerManager;
    }

    return self;
}

- (void)navigateToDinnerList {
  DinnerListViewController *dinnerListViewController = [[TyphoonComponentFactory defaultFactory] componentForType:[DinnerListViewController class]];
  [self.navigationController pushViewController:dinnerListViewController animated:YES];
}

- (IBAction)signIn {
  [self.loginManager signIn];
}

@end