//
// Created by Marek Moscichowski on 06/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerManager.h"
#import "DinnerTimeServiceSpy.h"
#import "DinnerTimeService.h"


@implementation DinnerManager {

}

- (void)getDinners:(void (^)(DinnerServiceResultType type))pFunction {
  [self.dinnerTimeService getDinners:^(NSArray *array) {
  }                          failure:^(DinnerServiceResultType type) {
  }];
}


@end