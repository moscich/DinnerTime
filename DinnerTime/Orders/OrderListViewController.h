//
// Created by Marek Moscichowski on 27/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AddOrderViewController.h"

@class DinnerManager;


@interface OrderListViewController : UIViewController <AddOrderViewControllerDelegate>

@property(nonatomic, strong) DinnerManager *dinnerManager;
@property(nonatomic, strong) IBOutlet UITableView *tableView;

- (instancetype)initWithDinnerManager:(DinnerManager *)dinnerManager;
- (void)addButtonTapped;

@end