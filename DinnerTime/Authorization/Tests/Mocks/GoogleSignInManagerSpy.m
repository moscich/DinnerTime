//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "GoogleSignInManagerSpy.h"


@implementation GoogleSignInManagerSpy {

}

- (void)signIn{
  self.signInCalled = YES;
}

@end