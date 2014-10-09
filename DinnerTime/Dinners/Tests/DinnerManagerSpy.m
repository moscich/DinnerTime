//
// Created by Marek Moscichowski on 09/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerManagerSpy.h"


@implementation DinnerManagerSpy {

}

- (void)getDinners:(void (^)())pFunction {
  self.getDinnersAsked = YES;
}

@end