//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleSignInManager.h"
#import "DinnerTimeLoginManager.h"

@class GoogleSignInManager;
@class DinnerTimeLoginManager;
@class LoginManagerDelegateSpy;

@protocol LoginManagerDelegate
- (void)loginManagerLoginSuccessful;
@end

@interface LoginManager : NSObject <GoogleSignInManagerDelegate, DinnerTimeLoginManagerDelegate>

@property(nonatomic, weak) IBOutlet id<LoginManagerDelegate> delegate;

@property(nonatomic, strong) GoogleSignInManager *googleManger;
@property(nonatomic, strong) DinnerTimeLoginManager *dinnerTimeLoginManager;

- (IBAction)signIn;

- (id)initWithGoogleSignInManager:(GoogleSignInManager *)googleSignInManager withDinnerTimeLoginManager:(DinnerTimeLoginManager *)loginManager;
@end