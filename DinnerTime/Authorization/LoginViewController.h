//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginManager.h"


@interface LoginViewController : UIViewController <LoginManagerDelegate>
@property(nonatomic, strong)  LoginManager *loginManager;

- (IBAction)loginButtonTapped;

@end