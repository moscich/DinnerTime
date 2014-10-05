//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoogleSignInManager;


@interface LoginManager : NSObject
@property(nonatomic, strong) GoogleSignInManager *googleManger;

- (void)signIn;

- (id)initWithGoogleSignInManager:(GoogleSignInManager *)spy;
@end