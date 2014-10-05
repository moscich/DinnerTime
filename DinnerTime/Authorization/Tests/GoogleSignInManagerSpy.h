//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleSignInManager.h"


@interface GoogleSignInManagerSpy : GoogleSignInManager
@property (nonatomic, assign) BOOL signInCalled;
@end