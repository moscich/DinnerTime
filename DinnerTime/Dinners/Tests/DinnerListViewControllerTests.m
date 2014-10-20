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
#import "LoginViewController.h"

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
  XCTAssertTrue(dinnerListViewController.dinnerManager.needUpdate);
}

- (void)testHidesBackButton{
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  dinnerListViewController.view;
  XCTAssertTrue(dinnerListViewController.navigationItem.hidesBackButton);
}

- (void)testDinnerListControllerHasProperlySetupInteractionWithLoginManager {
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  LoginManager *loginManager = [LoginManager new];
  dinnerListViewController.loginManager = loginManager;
  dinnerListViewController.view;
  XCTAssertEqual(dinnerListViewController.navigationItem.rightBarButtonItem.target, loginManager);
  XCTAssertEqual(loginManager.logoutDelegate, dinnerListViewController);
}

- (void)testDinnerListPopToLoginViewController{
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];

  id dinnerListViewControllerMock = [OCMockObject partialMockForObject:dinnerListViewController];
  id mockNavController = [OCMockObject mockForClass:[UINavigationController class]];
  [[[dinnerListViewControllerMock stub] andReturn:mockNavController] navigationController];

  [[mockNavController expect] popViewControllerAnimated:YES];
  [dinnerListViewController logoutManagerDidLogout];
  [mockNavController verify];
}

- (void)testReloadTableAfterSucceeding{
  id mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  [[mockTableView expect] reloadData];
  dinnerListViewController.tableView = mockTableView;
  DinnerManagerSpy *spy = [[DinnerManagerSpy alloc] initWithNeedsUpdate];
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
