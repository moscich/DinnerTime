//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DinnerTimeService.h"
#import "HttpSessionManagerSpy.h"
#import "UICKeyChainStore.h"
#import "OCMockObject.h"
#import "OCMStubRecorder.h"

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

- (void)testGetDinnersWithoutSessionId
{
  [UICKeyChainStore removeAllItems];
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  XCTestExpectation *failureExpectation = [self expectationWithDescription:@"failureCallback"];
  [dinnerTimeService getDinners:nil failure:^(DinnerServiceResultType type) {
    XCTAssertEqual(type, DinnerServiceResult_Unauthorized);
    [failureExpectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testDinnerServiceSetSessionInHeader{
  id mockRequestSerializer = [OCMockObject mockForClass:[AFHTTPRequestSerializer class]];
  HttpSessionManagerSpy *sessionManagerSpy = [[HttpSessionManagerSpy alloc] initWithReturnType:DinnerServiceResult_Unauthorized];
  [UICKeyChainStore setString:@"mockSessionId" forKey:@"session_id"];
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  id partialSessionManagerSpy = [OCMockObject partialMockForObject:sessionManagerSpy];
  [[[partialSessionManagerSpy stub] andReturn:mockRequestSerializer] requestSerializer];
  [[mockRequestSerializer expect] setValue:@"mockSessionId" forHTTPHeaderField:@"session_id"];
  dinnerTimeService.sessionManager = partialSessionManagerSpy;

  [dinnerTimeService getDinners:^(NSArray *array) {

  } failure:^(DinnerServiceResultType type) {

  }];

  [mockRequestSerializer verify];
}

- (void)testGetDinnersWhenUnauthorized{
  [UICKeyChainStore setString:@"mockSessionId" forKey:@"session_id"];
  HttpSessionManagerSpy *sessionManagerSpy = [[HttpSessionManagerSpy alloc] initWithReturnType:DinnerServiceResult_Unauthorized];
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  dinnerTimeService.sessionManager = sessionManagerSpy;
  XCTestExpectation *failureExpectation = [self expectationWithDescription:@"failureCallback"];
  [dinnerTimeService getDinners:nil failure:^(DinnerServiceResultType type) {
    XCTAssertEqual(type, DinnerServiceResult_Unauthorized);
    [failureExpectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

@end