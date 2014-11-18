//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginManager.h"

@class DinnerManager;
@class TyphoonAssembly;


@interface LoginViewController : UIViewController <LoginManagerDelegate>
@property(nonatomic, strong) TyphoonAssembly *assembly;
@property(nonatomic, strong) LoginManager *loginManager;
@property(nonatomic, strong) DinnerManager *dinnerManager;

- (IBAction)signIn;


- (instancetype)initWithDinnerManager:(DinnerManager *)dinnerManager loginManager:(LoginManager *)loginManager;

@end