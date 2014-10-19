//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DinnerManager.h"
#import "LoginManager.h"

@interface DinnerListViewController : UIViewController
@property(nonatomic, strong) DinnerManager *dinnerManager;

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property(nonatomic, strong) LoginManager *loginManager;
@end