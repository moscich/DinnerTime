//
// Created by Marek Moscichowski on 27/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "OrderListViewController.h"
#import "DinnerManager.h"
#import "OrderListManager.h"
#import "AddOrderViewController.h"

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
  self.tableView.delegate = self.dinnerManager.orderListManager;
  [self.tableView registerNib:[UINib nibWithNibName:@"DinnerSummaryCell" bundle:nil] forCellReuseIdentifier:@"DinnerSummaryCellIdentifier"];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
}

- (void)addButtonTapped {
    AddOrderViewController *addOrderViewController = [AddOrderViewController new];
    addOrderViewController.delegate = self;
    [self presentViewController:addOrderViewController animated:YES completion:nil];
}

- (void)addNewOrderNamed:(NSString *)title {
    [self.dinnerManager postOrder:title withCallback:^(DinnerServiceResultType type) {
        [self.tableView reloadData];
    }];
}

@end