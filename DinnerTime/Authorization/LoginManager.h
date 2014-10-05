//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleSignInManager.h"

@class GoogleSignInManager;
@class DinnerTimeLoginManager;


@interface LoginManager : NSObject <GoogleSignInManagerDelegate>
@property(nonatomic, strong) GoogleSignInManager *googleManger;

@property(nonatomic, strong) DinnerTimeLoginManager *dinnerTimeLoginManager;

- (void)signIn;

- (id)initWithGoogleSignInManager:(GoogleSignInManager *)googleSignInManager withDinnerTimeLoginManager:(DinnerTimeLoginManager *)loginManager;
@end