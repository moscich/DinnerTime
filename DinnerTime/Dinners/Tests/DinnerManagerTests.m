//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DinnerManager.h"
#import "DinnerTimeServiceSpy.h"
#import "DinnerServiceResultType.h"
#import "DinnerDTO.h"
#import "DinnerListViewDataSource.h"

@interface DinnerManagerTests : XCTestCase
@end

@implementation DinnerManagerTests {

}

- (void)testDinnerManagerInitsWithDinnerTimeService{
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  DinnerManager *dinnerManager = [[DinnerManager alloc] initWithDinnerTimeService:dinnerTimeService];
  XCTAssertEqual(dinnerManager.dinnerTimeService, dinnerTimeService);
}

- (void)testDinnerManagerGetsDinners{
  DinnerManager *dinnerManager = [DinnerManager new];
  XCTAssertNotEqual([dinnerManager lastResultType], DinnerServiceResult_Success);
  NSArray *resultArray = [self mockResultOutputArray];
  DinnerTimeServiceSpy *serviceSpy = [[DinnerTimeServiceSpy alloc] initWithArray:resultArray];
  dinnerManager.dinnerTimeService = serviceSpy;
  XCTestExpectation *callbackExpectation = [self expectationWithDescription:@"callbackExpectation"];
  [dinnerManager getDinners:^(DinnerServiceResultType type) {
    [callbackExpectation fulfill];
    XCTAssertEqual(type, DinnerServiceResult_Success);
    [self assertDinnerManagerProperDataSource:dinnerManager];
  }];
  XCTAssertTrue(serviceSpy.getDinnersCalled);
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)assertDinnerManagerProperDataSource:(id <DinnerListViewDataSource>)dataSource{
  XCTAssertEqual([dataSource tableView:nil numberOfRowsInSection:0],2);
  UITableViewCell *cell = [dataSource tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  XCTAssertEqualObjects(cell.textLabel.text, @"MockTitle");
  XCTAssertEqual([dataSource lastResultType], DinnerServiceResult_Success);
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

- (NSArray *)mockResultOutputArray {
  DinnerDTO *dinner1 = [DinnerDTO new];
  dinner1.dinnerId = 1;
  dinner1.owned = YES;
  dinner1.owner = @"MockOwner";
  dinner1.title = @"MockTitle";
  DinnerDTO *dinner2 = [DinnerDTO new];
  dinner2.dinnerId = 2;
  dinner2.owned = NO;
  dinner2.owner = @"MockOwner2";
  dinner2.title = @"MockTitle2";
  return @[dinner1, dinner2];
}

@end