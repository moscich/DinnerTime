//
//  DinnerListViewControllerTests.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 18/10/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DinnerListViewController.h"
#import "DinnerManagerSpy.h"

@interface DinnerListViewControllerTests : XCTestCase

@end

@implementation DinnerListViewControllerTests

- (void)testDinnerManagerHasTableViewProperlyInstantiated{
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  dinnerListViewController.dinnerManager = [DinnerManager new];
  dinnerListViewController.view;
  XCTAssertNotNil(dinnerListViewController.tableView.dataSource);
  XCTAssertNotNil(dinnerListViewController.tableView.delegate);
  XCTAssertEqual(dinnerListViewController.tableView.dataSource,dinnerListViewController.dinnerManager);
  XCTAssertEqual(dinnerListViewController.tableView.delegate,dinnerListViewController.dinnerManager);
}

- (void)testDinnerManagerGetsDinnersWhenDinnerManagerSucceed {
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  DinnerManagerSpy *spy = [[DinnerManagerSpy alloc] initWithResultType:DinnerServiceResult_Success];
  dinnerListViewController.dinnerManager = spy;
  dinnerListViewController.view;
  XCTAssertFalse(spy.getDinnersAsked);
}

- (void)testDinnerListHasProperlyConnectedLogoutButton {
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  LoginManager *loginManager = [LoginManager new];
  dinnerListViewController.loginManager = loginManager;
  dinnerListViewController.view;
  XCTAssertEqual(dinnerListViewController.navigationItem.rightBarButtonItem.target, loginManager);
}

- (void)testReloadTableAfterSucceeding{
  id mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  [[mockTableView expect] reloadData];
  dinnerListViewController.tableView = mockTableView;
  DinnerManagerSpy *spy = [[DinnerManagerSpy alloc] initWithResultType:DinnerServiceResult_Unauthorized];
  dinnerListViewController.dinnerManager = spy;
  [dinnerListViewController viewDidLoad];
  XCTAssertTrue(spy.getDinnersAsked);
  [mockTableView verify];
}

- (void)testRegisterNibInTableView{
  id mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  [[mockTableView expect] registerNib:OCMOCK_ANY forCellReuseIdentifier:@"DinnerCellIdentifier"];
  dinnerListViewController.tableView = mockTableView;
  [dinnerListViewController viewDidLoad];
  [mockTableView verify];
}

@end
