//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DinnerTimeService.h"
#import "HttpSessionManagerSpy.h"

@interface DinnerTimeServiceTests : XCTestCase
@end

@implementation DinnerTimeServiceTests {

}

- (void)testServiceInit{
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  XCTAssertNotNil(dinnerTimeService.sessionManager);
}

- (void)testDinnerTimeServiceLogin{
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  HttpSessionManagerSpy *sessionManagerSpy = [HttpSessionManagerSpy new];
  dinnerTimeService.sessionManager = sessionManagerSpy;
  XCTestExpectation *expectation = [self expectationWithDescription:@"callback"];
  [dinnerTimeService loginWithToken:@"TestToken" withCallback:^(NSString *sessionId) {
    XCTAssertEqualObjects(sessionId, @"testSessionID");
    [expectation fulfill];
  }];
  XCTAssertEqualObjects(sessionManagerSpy.parameters[@"token"], @"TestToken");
  XCTAssertEqualObjects(sessionManagerSpy.calledAddress, @"/login");
  [self waitForExpectationsWithTimeout:0.0001 handler:nil];
}

@end