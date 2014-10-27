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
#import "DinnerDTO.h"

@interface DinnerListViewControllerTests : XCTestCase

@end

@implementation DinnerListViewControllerTests

- (void)testDinnerManagerHasTableViewProperlyInstantiated {
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  dinnerListViewController.dinnerManager = [DinnerManager new];
  dinnerListViewController.view;
  XCTAssertNotNil(dinnerListViewController.tableView.dataSource);
  XCTAssertNotNil(dinnerListViewController.tableView.delegate);
  XCTAssertEqual(dinnerListViewController.tableView.dataSource, dinnerListViewController.dinnerManager);
  XCTAssertEqual(dinnerListViewController.tableView.delegate, dinnerListViewController.dinnerManager);
  XCTAssertEqual(dinnerListViewController.dinnerManager.delegate, dinnerListViewController);
}

- (void)testDinnerManagerGetsDinnersWhenDinnerManagerSucceed {
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  DinnerManagerSpy *spy = [[DinnerManagerSpy alloc] initWithResultType:DinnerServiceResult_Success];
  dinnerListViewController.dinnerManager = spy;
  dinnerListViewController.view;
  XCTAssertFalse(spy.getDinnersAsked);
  XCTAssertTrue(dinnerListViewController.dinnerManager.needUpdate);
}

- (void)testHidesBackButton {
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  dinnerListViewController.view;
  XCTAssertTrue(dinnerListViewController.navigationItem.hidesBackButton);
}

- (void)testDinnerListControllerHasProperlySetupInteractionWithLoginManager {
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  LoginManager *loginManager = [LoginManager new];
  dinnerListViewController.loginManager = loginManager;
  dinnerListViewController.view;
  XCTAssertEqual(dinnerListViewController.navigationItem.leftBarButtonItem.target, loginManager);
  XCTAssertEqual(dinnerListViewController.navigationItem.rightBarButtonItem.target, dinnerListViewController);
  XCTAssertEqual(loginManager.logoutDelegate, dinnerListViewController);
}

- (void)testDinnerPresentsAddDinnerModal {
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];

  id partialMock = [OCMockObject partialMockForObject:dinnerListViewController];
  [[partialMock expect] presentViewController:[OCMArg checkWithBlock:^BOOL(id obj) {
    if ([obj isKindOfClass:[AddDinnerViewController class]]) {
      AddDinnerViewController *addDinnerViewController = obj;
      return addDinnerViewController.delegate == dinnerListViewController;
    }
    return NO;
  }]                                 animated:YES completion:nil];
  [dinnerListViewController addButtonTapped];
  [partialMock verify];
}

- (void)testAddNewDinnerCalledInService{
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];

  id dinnerManager = [OCMockObject mockForClass:[DinnerManager class]];
  id mockTableView = [OCMockObject mockForClass:[UITableView class]];
  dinnerListViewController.dinnerManager = dinnerManager;
  dinnerListViewController.tableView = mockTableView;
  DinnerDTO *dinner = [DinnerDTO new];
  dinner.title = @"mockTitle";

  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)( DinnerServiceResultType);
    [invocation getArgument: &passedBlock atIndex: 3];
    passedBlock(DinnerServiceResult_Success);
  };

  [[[dinnerManager stub] andDo:proxyBlock] postDinner:[OCMArg checkWithBlock:^BOOL(id obj) {
    if ([obj isKindOfClass:[DinnerDTO class]]) {
      DinnerDTO *receivedDinner = obj;
      return [receivedDinner.title isEqualToString:@"mockTitle"];
    }
    return NO;
  }]             withCallback:OCMOCK_ANY];
  [[mockTableView expect] reloadData];
  [dinnerListViewController addDinnerViewControllerCreatedDinner:dinner];
  [dinnerManager verify];
  [mockTableView verify];
}

- (void)testDinnerListPopToLoginViewController {
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];

  id dinnerListViewControllerMock = [OCMockObject partialMockForObject:dinnerListViewController];
  id mockNavController = [OCMockObject mockForClass:[UINavigationController class]];
  [[[dinnerListViewControllerMock stub] andReturn:mockNavController] navigationController];

  [[mockNavController expect] popViewControllerAnimated:YES];
  [dinnerListViewController logoutManagerDidLogout];
  [mockNavController verify];
}

- (void)testReloadTableAfterSucceeding {
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

- (void)testRegisterNibInTableView {
  id mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  [[mockTableView expect] registerNib:OCMOCK_ANY forCellReuseIdentifier:@"DinnerCellIdentifier"];
  dinnerListViewController.tableView = mockTableView;
  [dinnerListViewController viewDidLoad];
  [mockTableView verify];
}

- (void)testAskForDinnerAfterDinnerUpdateNotification{
    id dinnerManager = [OCMockObject mockForClass:[DinnerManager class]];
    id tableView = [OCMockObject mockForClass:[UITableView class]];

    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
        void (^passedBlock)( DinnerServiceResultType);
        [invocation getArgument: &passedBlock atIndex: 2];
        passedBlock(DinnerServiceResult_Success);
    };

    [[[dinnerManager stub] andDo:proxyBlock ] getDinners:OCMOCK_ANY];
    [[tableView expect] reloadData];
    DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
    dinnerListViewController.view;
    dinnerListViewController.dinnerManager = dinnerManager;
    dinnerListViewController.tableView = tableView;

    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"DinnerUpdate" object:nil]];
    [dinnerManager verify];
    [tableView verify];
}

- (void)testNavigateToOrderListWith

@end
