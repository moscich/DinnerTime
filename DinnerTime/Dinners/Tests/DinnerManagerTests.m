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
#import "DinnerCell.h"

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

  XCTAssertEqual([dataSource lastResultType], DinnerServiceResult_Success);
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

@end