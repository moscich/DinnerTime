//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "LoginManagerDelegateSpy.h"


@implementation LoginManagerDelegateSpy {

}

- (void)loginManagerLoginSuccessful {
  self.wasCalled = YES;
}

@end