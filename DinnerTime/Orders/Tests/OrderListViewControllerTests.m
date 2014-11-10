//
//  OrderListViewControllerTests.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 27/10/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "OrderListViewController.h"
#import "DinnerManager.h"
#import "OrderListManager.h"
#import "AddOrderViewController.h"
#import "OrderDTO.h"

@interface OrderListViewControllerTests : XCTestCase

@end

@implementation OrderListViewControllerTests


- (void)testOrderListHasATableViewAndSetsItsDataSourceAndDelegate {
  DinnerManager *manager = [DinnerManager new];
  manager.orderListManager = [OrderListManager new];
  OrderListViewController *orderListViewController = [[OrderListViewController alloc] initWithDinnerManager:manager];
  [orderListViewController view];
  XCTAssertNotNil(orderListViewController.tableView);
  XCTAssertNotNil(orderListViewController.tableView.dataSource);
  XCTAssertNotNil(orderListViewController.tableView.delegate);
  XCTAssertFalse(orderListViewController.tableView.allowsSelection);
  XCTAssertEqual(orderListViewController.tableView.dataSource, manager.orderListManager);
  XCTAssertEqual(orderListViewController.tableView.delegate, manager.orderListManager);
}

- (void)testProperlyRegistersNibInTableView{
  id mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
  [[mockTableView expect] registerNib:OCMOCK_ANY forCellReuseIdentifier:@"DinnerSummaryCellIdentifier"];
  OrderListViewController *orderListViewController = [OrderListViewController new];
  orderListViewController.tableView = mockTableView;
  [orderListViewController viewDidLoad];
  [mockTableView verify];
}

- (void)testOrderListHasPlusButton {
  DinnerManager *manager = [DinnerManager new];
  OrderListViewController *orderListViewController = [[OrderListViewController alloc] initWithDinnerManager:manager];
  [orderListViewController view];
  XCTAssertEqual(orderListViewController.navigationItem.rightBarButtonItem.action, @selector(addButtonTapped));
  XCTAssertEqual(orderListViewController.navigationItem.rightBarButtonItem.target, orderListViewController);
}

- (void)testNewOrderControllerPresented {
  DinnerManager *manager = [DinnerManager new];
  OrderListViewController *orderListViewController = [[OrderListViewController alloc] initWithDinnerManager:manager];
  id partialOrderListViewController = [OCMockObject partialMockForObject:orderListViewController];
  [[partialOrderListViewController expect] presentViewController:[OCMArg checkWithBlock:^BOOL(id obj) {
    AddOrderViewController *addOrderViewController = obj;
    return addOrderViewController.delegate == orderListViewController;
  }]                                                    animated:YES completion:nil];
  [orderListViewController addButtonTapped];
  [partialOrderListViewController verify];
}

- (void)testPostNewOrder {
  id mockManager = [OCMockObject mockForClass:[DinnerManager class]];
  id mockTableView = [OCMockObject mockForClass:[UITableView class]];
  [[mockTableView expect] reloadData];
  OrderListViewController *orderListViewController = [[OrderListViewController alloc] initWithDinnerManager:mockManager];
  orderListViewController.tableView = mockTableView;
  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(DinnerServiceResultType);
    [invocation getArgument:&passedBlock atIndex:3];
    passedBlock(DinnerServiceResult_Success);
  };
  [[[mockManager stub] andDo:proxyBlock] postOrder:@"test" withCallback:OCMOCK_ANY];
  [orderListViewController addNewOrderNamed:@"test"];
  [mockManager verify];
  [mockTableView verify];
}

@end
