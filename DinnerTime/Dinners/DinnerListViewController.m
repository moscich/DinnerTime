//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerListViewController.h"
#import "AddDinnerViewController.h"


@implementation DinnerListViewController {

}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.hidesBackButton = YES;
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"turn_off"] style:UIBarButtonItemStylePlain target:self.loginManager action:@selector(logout)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
  self.loginManager.logoutDelegate = self;
  [self.tableView registerNib:[UINib nibWithNibName:@"DinnerCell" bundle:nil] forCellReuseIdentifier:@"DinnerCellIdentifier"];
  self.tableView.dataSource = self.dinnerManager;
  self.tableView.delegate = self.dinnerManager;
  if(self.dinnerManager.needUpdate){
    [self.dinnerManager getDinners:^(DinnerServiceResultType type) {
      [self.tableView reloadData];
    }];
  }
  self.dinnerManager.needUpdate = YES;
}

- (void)addButtonTapped {
    [self presentViewController:[AddDinnerViewController new] animated:YES completion:nil];
}

- (void)logoutManagerDidLogout {
  [self.navigationController popViewControllerAnimated:YES];
}

@end