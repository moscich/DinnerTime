//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DinnerManager.h"
#import "LoginManager.h"
#import "AddDinnerViewController.h"

@class DinnerTableViewDelegate;

@interface DinnerListViewController : UIViewController <LoginManagerLogoutDelegate, AddDinnerViewControllerDelegate>
@property(nonatomic, strong) DinnerManager *dinnerManager;
@property(nonatomic, strong) DinnerTableViewDelegate *dinnerTableViewDelegate;
@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property(nonatomic, strong) LoginManager *loginManager;

- (void)addButtonTapped;
@end