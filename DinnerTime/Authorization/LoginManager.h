//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleSignInManager.h"

@class GoogleSignInManager;
@class LoginManagerDelegateSpy;
@class DinnerTimeService;

@protocol LoginManagerDelegate
- (void)loginManagerLoginSuccessful;
@end

@interface LoginManager : NSObject <GoogleSignInManagerDelegate>

@property(nonatomic, weak) IBOutlet id<LoginManagerDelegate> delegate;

@property(nonatomic, strong) GoogleSignInManager *googleManger;

@property(nonatomic, strong) DinnerTimeService *dinnerTimeService;

- (IBAction)signIn;

- (id)initWithGoogleSignInManager:(GoogleSignInManager *)googleSignInManager withDinnerTimeService:(DinnerTimeService *)dinnerTimeService;

- (void)logout;
@end