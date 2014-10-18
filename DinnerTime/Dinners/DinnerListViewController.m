//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerListViewController.h"


@implementation DinnerListViewController {

}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView registerNib:[UINib nibWithNibName:@"DinnerCell" bundle:nil] forCellReuseIdentifier:@"DinnerCellIdentifier"];
  self.tableView.dataSource = self.dinnerManager;
  if([self.dinnerManager lastResultType] != DinnerServiceResult_Success){
    [self.dinnerManager getDinners:^(DinnerServiceResultType type) {
      [self.tableView reloadData];
    }];
  }
}

@end