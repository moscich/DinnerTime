//
//  OrderListManagerTests.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 27/10/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OrderListManager.h"
#import "OCMockObject.h"
#import "DinnerManager.h"
#import "OCMStubRecorder.h"
#import "DinnerDTO.h"
#import "OrderDTO.h"
#import "DinnerSummaryCell.h"

@interface OrderListManagerTests : XCTestCase

@end

@implementation OrderListManagerTests

- (void)testReturnsProperOrders {
  OrderListManager *orderListManager = [[OrderListManager alloc] initWithDinnerId:42];
  id mockDataSource = [OCMockObject mockForProtocol:@protocol(DinnerManagerDataSource)];
  orderListManager.dataSource = mockDataSource;
  [[[mockDataSource stub] andReturn:[self mockResultOutputArray]] dinnerManagerDinners];

  int numberOfRows = [orderListManager tableView:nil numberOfRowsInSection:1];
  XCTAssertEqual(numberOfRows, 2);

  UITableViewCell *cell = [orderListManager tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]];
  XCTAssertEqualObjects(cell.textLabel.text,@"Test order");
}

- (void)testFirstSectionHaveDinnerInfo{
  OrderListManager *orderListManager = [[OrderListManager alloc] initWithDinnerId:42];
  id mockDataSource = [OCMockObject mockForProtocol:@protocol(DinnerManagerDataSource)];
  orderListManager.dataSource = mockDataSource;
  [[[mockDataSource stub] andReturn:[self mockResultOutputArray]] dinnerManagerDinners];
  UITableView *tableView = [UITableView new];
  [tableView registerNib:[UINib nibWithNibName:@"DinnerSummaryCell" bundle:nil] forCellReuseIdentifier:@"DinnerSummaryCellIdentifier"];
  DinnerSummaryCell *cell = (DinnerSummaryCell *) [orderListManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  XCTAssertEqualObjects(cell.textLabel.text,@"MockTitle2");
  XCTAssertEqualObjects(cell.detailsLabel.text,@"MockDetails2");
  XCTAssertEqualObjects(cell.ownerLabel.text,@"MockOwner2");
}

- (void)testThereAreTwoSections{
  OrderListManager *orderListManager = [[OrderListManager alloc] initWithDinnerId:42];
  XCTAssertEqual([orderListManager numberOfSectionsInTableView:nil],2);
  XCTAssertEqual([orderListManager tableView:nil numberOfRowsInSection:0],1);
}

- (NSArray *)mockResultOutputArray {
  DinnerDTO *dinner1 = [DinnerDTO new];
  dinner1.dinnerId = 16;
  dinner1.owned = YES;
  dinner1.owner = @"MockOwner";
  dinner1.title = @"MockTitle";
  dinner1.details = @"MockDetails";
  OrderDTO *order1 = [OrderDTO new];
  order1.orderId = 1;
  order1.order = @"Order name";
  order1.owner = @"Test owner";
  order1.owned = YES;
  OrderDTO *order2 = [OrderDTO new];
  order2.orderId = 2;
  order2.order = @"Test order";
  order2.owner = @"Test owner 2";
  order2.owned = NO;
  dinner1.orders = (NSArray <OrderDTO> *) @[];
  DinnerDTO *dinner2 = [DinnerDTO new];
  dinner2.dinnerId = 42;
  dinner2.owned = NO;
  dinner2.owner = @"MockOwner2";
  dinner2.title = @"MockTitle2";
  dinner2.details = @"MockDetails2";
  dinner2.orders = (NSArray <OrderDTO> *) @[order1, order2];
  return @[dinner1, dinner2];
}

@end
