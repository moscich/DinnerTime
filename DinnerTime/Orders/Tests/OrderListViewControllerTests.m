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

@interface OrderListViewControllerTests : XCTestCase

@end

@implementation OrderListViewControllerTests


- (void)testOrderListHasATableViewAndSetsItsDataSource {
  DinnerManager *manager = [DinnerManager new];
  manager.orderListManager = [OrderListManager new];
  OrderListViewController *orderListViewController = [[OrderListViewController alloc] initWithDinnerManager:manager];
  [orderListViewController view];
  XCTAssertNotNil(orderListViewController.tableView);
  XCTAssertNotNil(orderListViewController.tableView.dataSource);
  XCTAssertEqual(orderListViewController.tableView.dataSource,manager.orderListManager);
}

- (void)testOrderListHasPlusButton{
    DinnerManager *manager = [DinnerManager new];
    OrderListViewController *orderListViewController = [[OrderListViewController alloc] initWithDinnerManager:manager];
    [orderListViewController view];
    XCTAssertEqual(orderListViewController.navigationItem.rightBarButtonItem.action,@selector(addButtonTapped));
    XCTAssertEqual(orderListViewController.navigationItem.rightBarButtonItem.target,orderListViewController);
}

- (void)testNewOrderControllerPresented{
    DinnerManager *manager = [DinnerManager new];
    OrderListViewController *orderListViewController = [[OrderListViewController alloc] initWithDinnerManager:manager];
    id partialOrderListViewController = [OCMockObject partialMockForObject:orderListViewController];
    [[partialOrderListViewController expect] presentViewController:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [obj isKindOfClass:[AddOrderViewController class]];
    }] animated:YES completion:nil];
    [orderListViewController addButtonTapped];
    [partialOrderListViewController verify];
}

@end
