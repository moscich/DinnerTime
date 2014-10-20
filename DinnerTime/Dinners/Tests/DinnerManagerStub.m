//
// Created by Marek Moscichowski on 09/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerManagerStub.h"
#import "DinnerServiceResultType.h"


@implementation DinnerManagerStub {

}

- (instancetype)initWithReturnType:(DinnerServiceResultType)type {
  self = [super initWithDinnerTimeService:nil];
  if (self) {
    self.type = type;
  }

  return self;
}

- (void)getDinners:(void (^)(DinnerServiceResultType type))callback {
  callback(self.type);
}


@end