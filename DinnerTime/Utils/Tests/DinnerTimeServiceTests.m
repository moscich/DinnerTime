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
#import "DinnerDTO.h"

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

- (void)testGetDinnersWithoutSessionId{
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
  HttpSessionManagerSpy *sessionManagerSpy = [HttpSessionManagerSpy new];
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

- (void)testGetDinnersSucceed{
  [UICKeyChainStore setString:@"mockSessionId" forKey:@"session_id"];
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  HttpSessionManagerSpy *sessionManagerSpy = [[HttpSessionManagerSpy alloc] initWithResultArray:[self mockResultInputArray]];
  dinnerTimeService.sessionManager = sessionManagerSpy;
  XCTestExpectation *successExpectation = [self expectationWithDescription:@"successCallback"];
  [dinnerTimeService getDinners:^(NSArray *array) {
    XCTAssertEqualObjects(array, [self mockResultOutputArray]);
    [successExpectation fulfill];
  } failure:^(DinnerServiceResultType type) {

  }];
  [self waitForExpectationsWithTimeout:0 handler:nil];
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

- (NSArray *)mockResultOutputArray
{
  DinnerDTO *dinner1 = [DinnerDTO new];
  dinner1.id = 1;
  dinner1.owned = YES;
  dinner1.owner = @"MockOwner";
  dinner1.title = @"MockTitle";
  DinnerDTO *dinner2 = [DinnerDTO new];
  dinner2.id = 2;
  dinner2.owned = NO;
  dinner2.owner = @"MockOwner2";
  dinner2.title = @"MockTitle2";
  return @[dinner1, dinner2];
}

- (NSArray *)mockResultInputArray {
  return @[
          @{
                  @"dinner_id":@(1),
                  @"owned":@(YES),
                  @"owner":@"MockOwner",
                  @"title":@"MockTitle"
          },
          @{
                  @"dinner_id":@(2),
                  @"owned":@(NO),
                  @"owner":@"MockOwner2",
                  @"title":@"MockTitle2"
          },
  ];
}

@end