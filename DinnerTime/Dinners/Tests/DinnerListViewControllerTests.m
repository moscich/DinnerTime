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
#import <Typhoon/TyphoonBlockComponentFactory.h>
#import "DinnerListViewController.h"
#import "DinnerManagerSpy.h"
#import "DinnerDTO.h"
#import "OrderListViewController.h"
#import "ApplicationAssembly.h"
#import "ModelAssembly.h"
#import "DinnerTimeServiceAssembly.h"
#import "ControllerAssembly.h"

@interface DinnerListViewControllerTests : XCTestCase

@property(nonatomic, strong) DinnerListViewController *dinnerListViewController;
@end

@implementation DinnerListViewControllerTests

- (void)setUp {
  TyphoonComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[[ApplicationAssembly assembly], [ModelAssembly assembly], [DinnerTimeServiceAssembly assembly], [ControllerAssembly assembly]]];
  self.dinnerListViewController = [factory componentForType:[DinnerListViewController class]];
}

- (void)testDinnerManagerHasTableViewProperlyInstantiated {
  self.dinnerListViewController.dinnerManager = [DinnerManager new];
  self.dinnerListViewController.view;
  XCTAssertNotNil(self.dinnerListViewController.tableView.dataSource);
  XCTAssertNotNil(self.dinnerListViewController.tableView.delegate);
  XCTAssertEqual(self.dinnerListViewController.tableView.dataSource, self.dinnerListViewController.dinnerManager.dinnerListManager);
  XCTAssertEqual(self.dinnerListViewController.tableView.delegate, self.dinnerListViewController.dinnerManager);
  XCTAssertEqual(self.dinnerListViewController.dinnerManager.delegate, self.dinnerListViewController);
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
  id partialMock = [OCMockObject partialMockForObject:  self.dinnerListViewController];
  [[partialMock expect] presentViewController:[OCMArg checkWithBlock:^BOOL(id obj) {
    if ([obj isKindOfClass:[AddDinnerViewController class]]) {
      AddDinnerViewController *addDinnerViewController = obj;
      return addDinnerViewController.delegate == self.dinnerListViewController;
    }
    return NO;
  }]                                 animated:YES completion:nil];
  [self.dinnerListViewController addButtonTapped];
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

- (void)testUnauthorizedGetDinners{
  id mockDinnerManager = [OCMockObject niceMockForClass:[DinnerManager class]];
  id mockNavController = [OCMockObject mockForClass:[UINavigationController class]];
  [[mockNavController expect] popViewControllerAnimated:YES];
  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)( DinnerServiceResultType);
    [invocation getArgument: &passedBlock atIndex: 2];
    passedBlock(DinnerServiceResult_Unauthorized);
  };

  [[[mockDinnerManager stub] andDo:proxyBlock] getDinners:OCMOCK_ANY];
  self.dinnerListViewController.dinnerManager = mockDinnerManager;
  id partialDinnerListViewControllerMock = [OCMockObject partialMockForObject:self.dinnerListViewController];
  [[[partialDinnerListViewControllerMock stub] andReturn:mockNavController] navigationController];

  [self.dinnerListViewController viewDidLoad];
  [mockDinnerManager verify];
  [mockNavController verify];
}

- (void)testNavigateToOrders{
  id mockNavController = [OCMockObject mockForClass:[UINavigationController class]];
  id partialDinnerListViewControllerMock = [OCMockObject partialMockForObject:self.dinnerListViewController];
  [[[partialDinnerListViewControllerMock stub] andReturn:mockNavController] navigationController];
  [[mockNavController expect] pushViewController:[OCMArg checkWithBlock:^BOOL(id obj) {
    if([obj isKindOfClass:[OrderListViewController class]]){
      OrderListViewController *orderListViewController = obj;
      return orderListViewController.dinnerManager == self.dinnerListViewController.dinnerManager;
    }
    return NO;
  }] animated:YES];

  id <DinnerManagerDelegate> dinerManagerDelegate = self.dinnerListViewController;
  [dinerManagerDelegate dinnerManagerDidSelectDinner];

  [mockNavController verify];
}

@end
