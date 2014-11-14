//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerListViewController.h"
#import "DinnerDTO.h"
#import "DinnerListManager.h"
#import "OrderListViewController.h"


@implementation DinnerListViewController {

}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.hidesBackButton = YES;
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"turn_off"] style:UIBarButtonItemStylePlain target:self.loginManager action:@selector(logout)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
  self.loginManager.logoutDelegate = self;
  [self.tableView registerNib:[UINib nibWithNibName:@"DinnerCell" bundle:nil] forCellReuseIdentifier:@"DinnerCellIdentifier"];
  self.tableView.dataSource = self.dinnerManager.dinnerListManager;
  self.tableView.delegate = self.dinnerManager;
  self.dinnerManager.delegate = self;
  [self updateDinners];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDinnerUpdate) name:@"DinnerUpdate" object:nil];
}

- (instancetype)initWithDinnerManager:(DinnerManager *)dinnerManager loginManager:(LoginManager *)loginManager {
    self = [super init];
    if (self) {
        self.dinnerManager = dinnerManager;
        self.loginManager = loginManager;
    }

    return self;
}

- (void)didReceiveDinnerUpdate {
    [self updateDinners];
}

- (void)updateDinners {
    [self.dinnerManager getDinners:^(DinnerServiceResultType type) {
      switch (type){
        case DinnerServiceResult_Success:
          [self.tableView reloadData];
          break;
        case DinnerServiceResult_Unauthorized:
          [self.navigationController popViewControllerAnimated:YES];
          break;
        default:
          break;
      }
    }];
}

- (void)addButtonTapped {
  AddDinnerViewController *addDinnerViewController = [AddDinnerViewController new];
  addDinnerViewController.delegate = self;
  [self presentViewController:addDinnerViewController animated:YES completion:nil];
}

- (void)logoutManagerDidLogout {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)addDinnerViewControllerCreatedDinner:(DinnerDTO *)dinnerDTO {
  [self.dinnerManager postDinner:dinnerDTO withCallback:^(DinnerServiceResultType type) {
    [self.tableView reloadData];
  }];
}

- (void)dinnerManagerDidSelectDinner {
  [self.navigationController pushViewController:[[OrderListViewController alloc] initWithDinnerManager:self.dinnerManager] animated:YES];
}

@end