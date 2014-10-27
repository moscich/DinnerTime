//
// Created by Marek Moscichowski on 27/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "OrderListViewController.h"
#import "DinnerManager.h"
#import "OrderListManager.h"

@implementation OrderListViewController {

}

- (instancetype)initWithDinnerManager:(DinnerManager *)dinnerManager {
  self = [super init];
  if (self) {
    self.dinnerManager = dinnerManager;
  }

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.dataSource = self.dinnerManager.orderListManager;
}

@end