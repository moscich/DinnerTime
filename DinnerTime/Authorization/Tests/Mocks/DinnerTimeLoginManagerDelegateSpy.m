//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerTimeLoginManagerDelegateSpy.h"


@implementation DinnerTimeLoginManagerDelegateSpy {

}
- (void)dinnerTimeLoginManagerLoginSuccessfully {
  self.wasCalled = YES;
}


@end