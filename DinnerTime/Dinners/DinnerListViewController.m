//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerListViewController.h"


@implementation DinnerListViewController {

}

- (instancetype)initWithDinnerManager:(DinnerManager *)dinnerManager {
  self = [super init];
  if (self) {
    self.dinnerManager = dinnerManager;
  }

  return self;
}

@end