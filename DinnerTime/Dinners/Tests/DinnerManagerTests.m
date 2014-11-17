// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerWebSocketServiceImpl.h"
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Typhoon/TyphoonComponentFactory.h>
#import <Typhoon/TyphoonBlockComponentFactory.h>
#import "DinnerManager.h"
#import "DinnerTimeServiceSpy.h"
#import "DinnerDTO.h"
#import "DinnerCell.h"
#import "DinnerArrayDTO.h"
#import "DinnerListManager.h"
#import "OrderListManager.h"
#import "OrderDTO.h"
#import "ModelAssembly.h"
#import "DinnerTimeServiceAssembly.h"
#import "ApplicationAssembly.h"

@interface DinnerManagerTests : XCTestCase

@property (nonatomic, strong) DinnerManager *dinnerManager;

@end

@implementation DinnerManagerTests {

}

- (void)setUp {
  TyphoonComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[[ApplicationAssembly assembly], [ModelAssembly assembly], [DinnerTimeServiceAssembly assembly]]];
  self.dinnerManager = [factory componentForType:[DinnerManager class]];
}

- (void)testInitsWithDinnerTimeServiceAndWebSockets {
  XCTAssertNotNil(self.dinnerManager.dinnerTimeService);
  XCTAssertNotNil(self.dinnerManager.webSocketService);
  XCTAssertEqual(self.dinnerManager.webSocketService.delegate, self.dinnerManager);
}

- (void)testDinnerManagerGetsDinners {
  NSArray *resultArray = [self mockResultOutputArray];
  DinnerTimeServiceSpy *serviceSpy = [[DinnerTimeServiceSpy alloc] initWithArray:resultArray];
  self.dinnerManager.dinnerTimeService = serviceSpy;
  XCTestExpectation *callbackExpectation = [self expectationWithDescription:@"callbackExpectation"];
  [self.dinnerManager getDinners:^(DinnerServiceResultType type) {
    [callbackExpectation fulfill];
    XCTAssertEqual(type, DinnerServiceResult_Success);
    [self assertDinnerManagerProperDataSourceSortsDinnersProperly:self.dinnerManager.dinnerListManager];
    self.dinnerManager.orderListManager = [[OrderListManager alloc] initWithDinnerId:2];
    self.dinnerManager.orderListManager.dataSource = self.dinnerManager;
    [self assertDinnerManagerHasProperOrders:self.dinnerManager.orderListManager];
  }];
  XCTAssertTrue(serviceSpy.getDinnersCalled);
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)assertDinnerManagerHasProperOrders:(id <UITableViewDataSource>)dataSource {
  XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:1], 2);
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
  DinnerTimeServiceSpy *serviceSpy = [[DinnerTimeServiceSpy alloc] initWithArray:nil];
  self.dinnerManager.dinnerTimeService = serviceSpy;
  XCTestExpectation *callbackExpectation = [self expectationWithDescription:@"callbackExpectation"];
  [self.dinnerManager getDinners:^(DinnerServiceResultType type) {
    [callbackExpectation fulfill];
    XCTAssertEqual(type, DinnerServiceResult_Unauthorized);
  }];
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testDinnerManagerReturnsProperHeight {
  id <UITableViewDelegate> tableViewDelegate = self.dinnerManager;
  XCTAssertEqual([tableViewDelegate tableView:nil heightForRowAtIndexPath:nil], 60);
}

- (void)testPostDinner {
  id dinnerTimeService = [OCMockObject mockForClass:[DinnerTimeServiceImpl class]];
  self.dinnerManager.dinnerTimeService = dinnerTimeService;
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
  [self.dinnerManager postDinner:dinner withCallback:^(DinnerServiceResultType type) {
    XCTAssertEqual(type, DinnerServiceResult_Success);
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:0 handler:nil];
  [dinnerTimeService verify];
  NSInteger numberOfRows = [self.dinnerManager.dinnerListManager tableView:nil numberOfRowsInSection:0];
  XCTAssertEqual(numberOfRows, 1);

  UITableView *tableView = [UITableView new];
  [tableView registerNib:[UINib nibWithNibName:@"DinnerCell" bundle:nil] forCellReuseIdentifier:@"DinnerCellIdentifier"];
  DinnerCell *cell = (DinnerCell *) [self.dinnerManager.dinnerListManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
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

  id partialDinnerManagerMock = [OCMockObject partialMockForObject:self.dinnerManager];
  [[[partialDinnerManagerMock stub] andReturn:[self sortedMockDinnerArray]] dinners];

  [self.dinnerManager postDinner:dinner withCallback:^(DinnerServiceResultType type) {
  }];

  [partialDinnerManagerMock stopMocking];

  DinnerCell *cell0 = (DinnerCell *) [self.dinnerManager.dinnerListManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  DinnerCell *cell1 = (DinnerCell *) [self.dinnerManager.dinnerListManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
  DinnerCell *cell2 = (DinnerCell *) [self.dinnerManager.dinnerListManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
  XCTAssertEqualObjects(cell0.textLabel.text, @"new dinner title");
  XCTAssertEqualObjects(cell1.textLabel.text, @"MockTitle");
  XCTAssertEqualObjects(cell2.textLabel.text, @"MockTitle2");
}

- (void)testPostOrder {
  OrderListManager *orderListManager = [OrderListManager new];
  orderListManager.dinnerId = 2;
  self.dinnerManager.orderListManager = orderListManager;
  self.dinnerManager.dinners = (NSMutableArray *) [[self mockResultOutputArray] mutableCopy];
  id mockService = [OCMockObject mockForClass:[DinnerTimeServiceImpl class]];
  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(OrderDTO *);
    OrderDTO *order = [self mockOrderPostResultWithID:42];
    [invocation getArgument:&passedBlock atIndex:4];
    passedBlock(order);
  };
  [[[mockService stub] andDo:proxyBlock] postOrder:@"test" withDinnerId:2 withCallback:OCMOCK_ANY];
  self.dinnerManager.dinnerTimeService = mockService;
  XCTestExpectation *expectation = [self expectationWithDescription:@"callbackExpectation"];
  [self.dinnerManager postOrder:@"test" withCallback:^(DinnerServiceResultType type) {
    [expectation fulfill];
    XCTAssertEqual(type, DinnerServiceResult_Success);
  }];
  [mockService verify];
  DinnerDTO *dinner = self.dinnerManager.dinners[1];
  XCTAssertEqualObjects([dinner.orders firstObject], [self mockOrderPostResultWithID:42]);
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testSendNotificationWhenUpdateArrives {
  id mock = [OCMockObject observerMock];
  [[NSNotificationCenter defaultCenter] addMockObserver:mock name:@"DinnerUpdate" object:nil];
  [[mock expect] notificationWithName:@"DinnerUpdate" object:[OCMArg any]];
  [self.dinnerManager webSocketReceivedDinnerUpdate:@42];
  [mock verify];
}

- (void)testRowTapSetOrderListAndCallDelegate {
  id mockDelegate = [OCMockObject mockForProtocol:@protocol(DinnerManagerDelegate)];
  [[mockDelegate expect] dinnerManagerDidSelectDinner];
  self.dinnerManager.delegate = mockDelegate;
  self.dinnerManager.dinners = (NSMutableArray *) [[self mockResultOutputArray] mutableCopy];
  [self.dinnerManager tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
  [mockDelegate verify];
  XCTAssertEqual(self.dinnerManager.orderListManager.dinnerId, 2);
  XCTAssertEqual(self.dinnerManager.orderListManager.dataSource, self.dinnerManager);
  XCTAssertEqual(self.dinnerManager.orderListManager.delegate, self.dinnerManager);
}

- (void)testChangeOrderStateSendToDinnerService {
  OrderListManager *orderListManager = [[OrderListManager alloc] initWithDinnerId:2];
  self.dinnerManager.dinners = [[self mockResultOutputArray] mutableCopy];
  self.dinnerManager.orderListManager = orderListManager;
  id mockService = [OCMockObject mockForClass:[DinnerTimeServiceImpl class]];
  self.dinnerManager.dinnerTimeService = mockService;
  [[mockService expect] changeOrderWithId:@24 toPaid:@YES];
  [self.dinnerManager orderWasPaid:@1];
  [mockService verify];
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
  dinner2.orders = (NSArray <OrderDTO, Optional> *) @[[self mockOrderPostResultWithID:42], [self mockOrderPostResultWithID:24]];
  return @[dinner1, dinner2];
}

- (OrderDTO *)mockOrderPostResultWithID:(int)orderID {
  OrderDTO *order = [OrderDTO new];
  order.order = @"testOrder";
  order.owner = @"testOwner";
  order.orderId = orderID;
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