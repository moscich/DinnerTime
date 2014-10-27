//
// Created by Marek Moscichowski on 09/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerManagerSpy.h"


@implementation DinnerManagerSpy {

}

- (DinnerServiceResultType)lastResultType {
  return self.resultType;
}

- (id)initWithResultType:(DinnerServiceResultType)type {
  self = [super init];
  if (self) {
    self.resultType = type;
  }

  return self;
}

- (void)getDinners:(void (^)(DinnerServiceResultType))pFunction {
  pFunction(DinnerServiceResult_Success);
  self.getDinnersAsked = YES;
  [NSThread sleepForTimeInterval:0.01f];
}

- (id)initWithNeedsUpdate {
    self = [super init];
    if (self) {
    }

    return self;
}

@end