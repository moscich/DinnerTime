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
#import "DinnerSessionBuilder.h"
#import "DinnerSessionManager.h"
#import "DinnerSessionManagerSpy.h"
#import "DinnerSessionBuilderStub.h"

@interface DinnerTimeServiceTests : XCTestCase
@end

@implementation DinnerTimeServiceTests {

}

- (void)testDinnerTimeServiceInstantiateSessionManagerWithSessionBuilder {
  id dinnerSessionBuilderMock = [OCMockObject mockForClass:[DinnerSessionBuilder class]];
  DinnerSessionManager *sessionManager = [DinnerSessionManager new];
  [[[dinnerSessionBuilderMock stub] andReturn:sessionManager] constructSessionManager];
  DinnerTimeService *dinnerTimeService = [[DinnerTimeService alloc] initWithDinnerSessionBuilder:dinnerSessionBuilderMock];
  XCTAssertEqual(dinnerTimeService.dinnerSessionManager, sessionManager);
}

- (void)testDinnerTimeServiceLogin {
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  NSString *sessionJSON = @"{\"sessionId\":\"testSessionId\"}";
  DinnerSessionManagerSpy *dinnerSessionManagerSpy = [[DinnerSessionManagerSpy alloc] initWithSessionJSON:sessionJSON];
  dinnerTimeService.dinnerSessionManager = dinnerSessionManagerSpy;
  XCTestExpectation *expectation = [self expectationWithDescription:@"callback"];
  [dinnerTimeService loginWithToken:@"TestToken" withCallback:^(NSString *sessionId) {
    XCTAssertEqualObjects(sessionId, @"testSessionId");
    [expectation fulfill];
  }];
  XCTAssertEqualObjects(dinnerSessionManagerSpy.parameters[@"token"], @"TestToken");
  XCTAssertEqualObjects(dinnerSessionManagerSpy.postCalledAddress, @"/login");
  XCTAssertEqualObjects(dinnerSessionManagerSpy.sessionId, @"testSessionId");
  XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"session_id"], @"testSessionId");
  [self waitForExpectationsWithTimeout:0.0001 handler:nil];
}

- (void)testDinnerServiceSetSessionInHeader {
  DinnerSessionManager *dinnerSessionManager = [DinnerSessionManager new];
  [UICKeyChainStore setString:@"mockSessionId" forKey:@"session_id"];
  DinnerSessionBuilderStub *dinnerSessionBuilderStub = [[DinnerSessionBuilderStub alloc] initWithDinnerSessionManager:dinnerSessionManager];
  DinnerTimeService *dinnerTimeService = [[DinnerTimeService alloc] initWithDinnerSessionBuilder:dinnerSessionBuilderStub];

  [dinnerTimeService getDinners:^(NSArray *array) {

  }failure:^(DinnerServiceResultType type) {

  }];

  XCTAssertEqualObjects(dinnerSessionManager.sessionId, @"mockSessionId");
}

- (void)testGetDinnersSucceed {
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  DinnerSessionManagerSpy *dinnerSessionManagerSpy = [[DinnerSessionManagerSpy alloc] initWithDinnerJSON:[self mockResultJSONString]];
  dinnerTimeService.dinnerSessionManager = dinnerSessionManagerSpy;
  XCTestExpectation *successExpectation = [self expectationWithDescription:@"successCallback"];
  [dinnerTimeService getDinners:^(NSArray *dinnerArray) {
    NSArray *array = [self mockResultOutputArray];
    XCTAssertEqualObjects(dinnerArray, array);
    [successExpectation fulfill];
  }failure:^(DinnerServiceResultType type) {

  }];
  XCTAssertEqualObjects(dinnerSessionManagerSpy.getCalledAddress, @"/dinners");
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testGetDinnersWhenUnauthorized {
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  DinnerSessionManagerSpy *dinnerSessionManagerSpy = [[DinnerSessionManagerSpy alloc] initWithResultType:DinnerServiceResult_Unauthorized];
  dinnerTimeService.dinnerSessionManager = dinnerSessionManagerSpy;
  XCTestExpectation *failureExpectation = [self expectationWithDescription:@"failureCallback"];
  [dinnerTimeService getDinners:nil failure:^(DinnerServiceResultType type) {
    XCTAssertEqual(type, DinnerServiceResult_Unauthorized);
    [failureExpectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testLogout{
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  DinnerSessionManagerSpy *dinnerSessionManagerSpy = [DinnerSessionManagerSpy new];
  dinnerTimeService.dinnerSessionManager = dinnerSessionManagerSpy;
  XCTestExpectation *expectation = [self expectationWithDescription:@"logoutCallback"];
  [dinnerTimeService logout:^(DinnerServiceResultType type) {
    [expectation fulfill];
  }];
  XCTAssertEqualObjects(dinnerSessionManagerSpy.postCalledAddress, @"/logout");
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

- (NSString *)mockResultJSONString {
  return @"{  "
          "   \"dinners\":[  "
          "      {  "
          "         \"dinnerId\":1,"
          "         \"title\":\"MockTitle\","
          "         \"owner\":\"MockOwner\","
          "         \"owned\":true"
          "      },"
          "      {  "
          "         \"dinnerId\":2,"
          "         \"title\":\"MockTitle2\","
          "         \"owner\":\"MockOwner2\","
          "         \"owned\":false"
          "      }]"
          "}";
}

@end