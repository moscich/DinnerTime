//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginManager.h"


@interface LoginManagerDelegateSpy : NSObject <LoginManagerDelegate>
@property (nonatomic, assign) BOOL wasCalled;
@end