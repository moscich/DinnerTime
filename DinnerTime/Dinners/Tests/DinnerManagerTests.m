#import "DinnerWebSocketManager.h"//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DinnerManager.h"
#import "DinnerTimeServiceSpy.h"
#import "DinnerDTO.h"
#import "DinnerCell.h"
#import "DinnerArrayDTO.h"
#import "DinnerListManager.h"
#import "OrderListManager.h"
#import "OrderDTO.h"

@interface DinnerManagerTests : XCTestCase
@end

@implementation DinnerManagerTests {

}

- (void)testInitsWithDinnerTimeServiceAndWebSockets {
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  DinnerManager *dinnerManager = [[DinnerManager alloc] initWithDinnerTimeService:dinnerTimeService];
  XCTAssertEqual(dinnerManager.dinnerTimeService, dinnerTimeService);
  XCTAssertNotNil(dinnerManager.webSocketManager);
  XCTAssertEqual(dinnerManager.webSocketManager.delegate, dinnerManager);
}

- (void)testDinnerManagerGetsDinners {
  NSArray *resultArray = [self mockResultOutputArray];
  DinnerTimeServiceSpy *serviceSpy = [[DinnerTimeServiceSpy alloc] initWithArray:resultArray];
  DinnerManager *dinnerManager = [[DinnerManager alloc] initWithDinnerTimeService:serviceSpy];
  XCTestExpectation *callbackExpectation = [self expectationWithDescription:@"callbackExpectation"];
  [dinnerManager getDinners:^(DinnerServiceResultType type) {
    [callbackExpectation fulfill];
    XCTAssertEqual(type, DinnerServiceResult_Success);
    [self assertDinnerManagerProperDataSourceSortsDinnersProperly:dinnerManager.dinnerListManager];
    dinnerManager.orderListManager = [[OrderListManager alloc] initWithDinnerId:2];
    dinnerManager.orderListManager.dataSource = dinnerManager;
    [self assertDinnerManagerHasProperOrders:dinnerManager.orderListManager];
  }];
  XCTAssertTrue(serviceSpy.getDinnersCalled);
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)assertDinnerManagerHasProperOrders:(id <UITableViewDataSource>)dataSource {
  XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:1],2);
}

- (void)assertDinnerManagerProperDataSourceSortsDinnersProperly:(id <UITableViewDataSource>)dataSource {
  UITableView *tableView = [UITableView new];
  [tableView registerNib:[UINib nibWithNibName:@"DinnerCell" bundle:nil] forCellReuseIdentifier:@"DinnerCellIdentifier"];
  XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0], 2);

  DinnerCell *firstCell = (DinnerCell *) [dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  [self assertDinnerCellProperlyInstantiated:firstCell];
  XCTAssertEqualObjects(firstCell.textLabel.text, @"MockTitle2");
  XCTAssertEqualObjects(firstCell.ownerLabel.text, @"MockOwner2");
  XCTAssertFalse(firstCell.ownerBackground.hidden);

  DinnerCell *secondCell = (DinnerCell *) [dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
  [self assertDinnerCellProperlyInstantiated:secondCell];
  XCTAssertEqualObjects(secondCell.textLabel.text, @"MockTitle");
  XCTAssertEqualObjects(secondCell.ownerLabel.text, @"MockOwner");
  XCTAssertTrue(secondCell.ownerBackground.hidden);
}

- (void)assertDinnerCellProperlyInstantiated:(DinnerCell *)dinnerCell {
  XCTAssertNotNil(dinnerCell.ownerLabel);
  XCTAssertNotNil(dinnerCell.ownerBackground);
}

- (void)testDinnerManagerUnauthorizedDinners {
  DinnerManager *dinnerManager = [DinnerManager new];
  DinnerTimeServiceSpy *serviceSpy = [[DinnerTimeServiceSpy alloc] initWithArray:nil];
  dinnerManager.dinnerTimeService = serviceSpy;
  XCTestExpectation *callbackExpectation = [self expectationWithDescription:@"callbackExpectation"];
  [dinnerManager getDinners:^(DinnerServiceResultType type) {
    [callbackExpectation fulfill];
    XCTAssertEqual(type, DinnerServiceResult_Unauthorized);
  }];
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testDinnerManagerReturnsProperHeight {
  id <UITableViewDelegate> tableViewDelegate = [DinnerManager new];
  XCTAssertEqual([tableViewDelegate tableView:nil heightForRowAtIndexPath:nil], 60);
}

- (void)testPostDinner {
  id dinnerTimeService = [OCMockObject mockForClass:[DinnerTimeService class]];
  DinnerManager *dinnerManager = [[DinnerManager alloc] initWithDinnerTimeService:dinnerTimeService];
  XCTestExpectation *expectation = [self expectationWithDescription:@"callbackExpectation"];
  DinnerDTO *dinner = [DinnerDTO new];
  dinner.title = @"mockTitle";

  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(DinnerDTO *);
    [invocation getArgument:&passedBlock atIndex:3];
    passedBlock(dinner);
  };

  [[[dinnerTimeService stub] andDo:proxyBlock] postDinner:[OCMArg checkWithBlock:^BOOL(id obj) {
    return obj == dinner;
  }]                                         withCallback:OCMOCK_ANY];
  [dinnerManager postDinner:dinner withCallback:^(DinnerServiceResultType type) {
    XCTAssertEqual(type, DinnerServiceResult_Success);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:0 handler:nil];
  [dinnerTimeService verify];
  NSInteger numberOfRows = [dinnerManager.dinnerListManager tableView:nil numberOfRowsInSection:0];
  XCTAssertEqual(numberOfRows, 1);

  UITableView *tableView = [UITableView new];
  [tableView registerNib:[UINib nibWithNibName:@"DinnerCell" bundle:nil] forCellReuseIdentifier:@"DinnerCellIdentifier"];
  DinnerCell *cell = (DinnerCell *) [dinnerManager.dinnerListManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  XCTAssertEqualObjects(cell.textLabel.text, dinner.title);

  dinner = [DinnerDTO new];
  dinner.title = @"new dinner title";

  void (^proxyBlock2)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(DinnerDTO *);
    [invocation getArgument:&passedBlock atIndex:3];
    passedBlock(dinner);
  };

  [[[dinnerTimeService stub] andDo:proxyBlock2] postDinner:[OCMArg checkWithBlock:^BOOL(id obj) {
    return obj == dinner;
  }]                                          withCallback:OCMOCK_ANY];

  id partialDinnerManagerMock = [OCMockObject partialMockForObject:dinnerManager];
  [[[partialDinnerManagerMock stub] andReturn:[self sortedMockDinnerArray]] dinners];

  [dinnerManager postDinner:dinner withCallback:^(DinnerServiceResultType type) {
  }];

  [partialDinnerManagerMock stopMocking];

  DinnerCell *cell0 = (DinnerCell *) [dinnerManager.dinnerListManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  DinnerCell *cell1 = (DinnerCell *) [dinnerManager.dinnerListManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
  DinnerCell *cell2 = (DinnerCell *) [dinnerManager.dinnerListManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
  XCTAssertEqualObjects(cell0.textLabel.text, @"new dinner title");
  XCTAssertEqualObjects(cell1.textLabel.text, @"MockTitle");
  XCTAssertEqualObjects(cell2.textLabel.text, @"MockTitle2");
}

- (void)testPostOrder {
  DinnerManager *dinnerManager = [DinnerManager new];
  OrderListManager *orderListManager = [OrderListManager new];
  orderListManager.dinnerId = 2;
  dinnerManager.orderListManager = orderListManager;
  dinnerManager.dinners = (NSMutableArray *) [[self mockResultOutputArray] mutableCopy];
  id mockService = [OCMockObject mockForClass:[DinnerTimeService class]];
  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(OrderDTO *);
    OrderDTO *order = [self mockOrderPostResult];
    [invocation getArgument:&passedBlock atIndex:4];
    passedBlock(order);
  };
  [[[mockService stub] andDo:proxyBlock] postOrder:@"test" withDinnerId:2 withCallback:OCMOCK_ANY];
  dinnerManager.dinnerTimeService = mockService;
  XCTestExpectation *expectation = [self expectationWithDescription:@"callbackExpectation"];
  [dinnerManager postOrder:@"test" withCallback:^(DinnerServiceResultType type) {
    [expectation fulfill];
    XCTAssertEqual(type, DinnerServiceResult_Success);
  }];
  [mockService verify];
  DinnerDTO *dinner = dinnerManager.dinners[1];
  XCTAssertEqualObjects([dinner.orders firstObject], [self mockOrderPostResult]);
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testSendNotificationWhenUpdateArrives {
  DinnerManager *dinnerManager = [DinnerManager new];
  id mock = [OCMockObject observerMock];
  [[NSNotificationCenter defaultCenter] addMockObserver:mock name:@"DinnerUpdate" object:nil];
  [[mock expect] notificationWithName:@"DinnerUpdate" object:[OCMArg any]];
  [dinnerManager webSocketReceivedDinnerUpdate:@42];
  [mock verify];
}

- (void)testRowTapSetOrderListAndCallDelegate {
  DinnerManager *dinnerManager = [DinnerManager new];
  id mockDelegate = [OCMockObject mockForProtocol:@protocol(DinnerManagerDelegate)];
  [[mockDelegate expect] dinnerManagerDidSelectDinner];
  dinnerManager.delegate = mockDelegate;
  dinnerManager.dinners = (NSMutableArray *) [[self mockResultOutputArray] mutableCopy];
  [dinnerManager tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
  [mockDelegate verify];
  XCTAssertEqual(dinnerManager.orderListManager.dinnerId, 2);
  XCTAssertEqual(dinnerManager.orderListManager.dataSource, dinnerManager);
}

- (NSArray *)mockResultOutputArray {
  DinnerDTO *dinner1 = [DinnerDTO new];
  dinner1.dinnerId = 1;
  dinner1.owned = NO;
  dinner1.owner = @"MockOwner";
  dinner1.title = @"MockTitle";
  DinnerDTO *dinner2 = [DinnerDTO new];
  dinner2.dinnerId = 2;
  dinner2.owned = YES;
  dinner2.owner = @"MockOwner2";
  dinner2.title = @"MockTitle2";
  dinner2.orders = (NSArray <OrderDTO, Optional> *) @[[self mockOrderPostResult], [self mockOrderPostResult]];
  return @[dinner1, dinner2];
}

- (OrderDTO *)mockOrderPostResult {
  OrderDTO *order = [OrderDTO new];
  order.order = @"testOrder";
  order.owner = @"testOwner";
  order.orderId = 42;
  order.owned = YES;
  return order;
}

- (NSMutableArray *)sortedMockDinnerArray {
  DinnerDTO *dinner = [DinnerDTO new];
  dinner.title = @"MockTitle";
  dinner.owned = YES;
  DinnerDTO *dinner2 = [DinnerDTO new];
  dinner2.title = @"MockTitle2";
  dinner2.owned = NO;
  return [@[dinner, dinner2] mutableCopy];
}

@end