//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DinnerManager.h"
#import "DinnerTimeServiceSpy.h"
#import "DinnerServiceResultType.h"

@interface DinnerManagerTests : XCTestCase
@end

@implementation DinnerManagerTests {

}

- (void)testDinnerManagerGetsDinners{
  DinnerManager *dinnerManager = [DinnerManager new];
  DinnerTimeServiceSpy *serviceSpy = [DinnerTimeServiceSpy new];
  dinnerManager.dinnerTimeService = serviceSpy;
  [dinnerManager getDinners:^(DinnerServiceResultType type) {

  }];
  XCTAssertTrue(serviceSpy.getDinnersCalled);
}

@end