//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DinnerManager.h"
#import "DinnerTimeServiceSpy.h"
#import "DinnerServiceResultType.h"
#import "DinnerDTO.h"
#import "DinnerListViewDataSource.h"
#import "DinnerCell.h"
#import "DinnerArrayDTO.h"

@interface DinnerManagerTests : XCTestCase
@end

@implementation DinnerManagerTests {

}

- (void)testInitsWithDinnerTimeServiceAndWebSockets{
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  DinnerManager *dinnerManager = [[DinnerManager alloc] initWithDinnerTimeService:dinnerTimeService];
  XCTAssertEqual(dinnerManager.dinnerTimeService, dinnerTimeService);
  XCTAssertTrue(dinnerManager.needUpdate);
  XCTAssertNotNil(dinnerManager.webSocketManager);
}

- (void)testDinnerManagerGetsDinners{
  DinnerManager *dinnerManager = [DinnerManager new];
  XCTAssertFalse(dinnerManager.needUpdate);
  NSArray *resultArray = [self mockResultOutputArray];
  DinnerTimeServiceSpy *serviceSpy = [[DinnerTimeServiceSpy alloc] initWithArray:resultArray];
  dinnerManager.dinnerTimeService = serviceSpy;
  XCTestExpectation *callbackExpectation = [self expectationWithDescription:@"callbackExpectation"];
  [dinnerManager getDinners:^(DinnerServiceResultType type) {
    [callbackExpectation fulfill];
    XCTAssertEqual(type, DinnerServiceResult_Success);
    [self assertDinnerManagerProperDataSourceSortsDinnersProperly:dinnerManager];
  }];
  XCTAssertTrue(serviceSpy.getDinnersCalled);
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)assertDinnerManagerProperDataSourceSortsDinnersProperly:(id <DinnerListViewDataSource>)dataSource{
  UITableView *tableView = [UITableView new];
  [tableView registerNib:[UINib nibWithNibName:@"DinnerCell" bundle:nil] forCellReuseIdentifier:@"DinnerCellIdentifier"];
  XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0],2);

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

  XCTAssertFalse(dataSource.needUpdate);
}

- (void)assertDinnerCellProperlyInstantiated:(DinnerCell *)dinnerCell{
  XCTAssertNotNil(dinnerCell.ownerLabel);
  XCTAssertNotNil(dinnerCell.ownerBackground);
}

- (void)testDinnerManagerUnauthorizedDinners{
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

- (void)testDinnerManagerReturnsProperHeight{
  id <UITableViewDelegate> tableViewDelegate = [DinnerManager new];
  XCTAssertEqual([tableViewDelegate tableView:nil heightForRowAtIndexPath:nil], 60);
}

- (void)testPostDinner{
  DinnerManager *dinnerManager = [DinnerManager new];
  id dinnerTimeService = [OCMockObject mockForClass:[DinnerTimeService class]];
  dinnerManager.dinnerTimeService = dinnerTimeService;
  XCTestExpectation *expectation = [self expectationWithDescription:@"callbackExpectation"];
  DinnerDTO *dinner = [DinnerDTO new];
  dinner.title = @"mockTitle";

  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(DinnerDTO *);
    [invocation getArgument: &passedBlock atIndex: 3];
    passedBlock(dinner);
  };

  [[[dinnerTimeService stub] andDo:proxyBlock] postDinner:[OCMArg checkWithBlock:^BOOL(id obj) {
    return obj == dinner;
  }] withCallback:OCMOCK_ANY];
  [dinnerManager postDinner:dinner withCallback:^(DinnerServiceResultType type) {
    [expectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:0 handler:nil];
  [dinnerTimeService verify];
  NSInteger numberOfRows = [dinnerManager tableView:nil numberOfRowsInSection:0];
  XCTAssertEqual(numberOfRows, 1);

  UITableView *tableView = [UITableView new];
  [tableView registerNib:[UINib nibWithNibName:@"DinnerCell" bundle:nil] forCellReuseIdentifier:@"DinnerCellIdentifier"];
  DinnerCell *cell = (DinnerCell *)[dinnerManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  XCTAssertEqualObjects(cell.textLabel.text,dinner.title);

  dinner = [DinnerDTO new];
  dinner.title = @"new dinner title";

  void (^proxyBlock2)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(DinnerDTO *);
    [invocation getArgument: &passedBlock atIndex: 3];
    passedBlock(dinner);
  };

  [[[dinnerTimeService stub] andDo:proxyBlock2] postDinner:[OCMArg checkWithBlock:^BOOL(id obj) {
    return obj == dinner;
  }] withCallback:OCMOCK_ANY];

  id partialDinnerManagerMock = [OCMockObject partialMockForObject:dinnerManager];
  [[[partialDinnerManagerMock stub] andReturn:[self sortedMockDinnerArray] ] dinners];

  [dinnerManager postDinner:dinner withCallback:^(DinnerServiceResultType type) {
  }];

  [partialDinnerManagerMock stopMocking];

  DinnerCell *cell0 = (DinnerCell *)[dinnerManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  DinnerCell *cell1 = (DinnerCell *)[dinnerManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
  DinnerCell *cell2 = (DinnerCell *)[dinnerManager tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
  XCTAssertEqualObjects(cell0.textLabel.text,@"new dinner title");
  XCTAssertEqualObjects(cell1.textLabel.text,@"MockTitle");
  XCTAssertEqualObjects(cell2.textLabel.text,@"MockTitle2");
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
  return @[dinner1, dinner2];
}

- (NSMutableArray *)sortedMockDinnerArray{
  DinnerDTO *dinner = [DinnerDTO new];
  dinner.title = @"MockTitle";
  dinner.owned = YES;
  DinnerDTO *dinner2 = [DinnerDTO new];
  dinner2.title = @"MockTitle2";
  dinner2.owned = NO;
  return [@[dinner, dinner2] mutableCopy];
}

@end