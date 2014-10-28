//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "DinnerTimeService.h"
#import "HttpSessionManagerSpy.h"
#import "UICKeyChainStore.h"
#import "DinnerDTO.h"
#import "DinnerSessionBuilder.h"
#import "DinnerSessionManager.h"
#import "DinnerSessionManagerSpy.h"
#import "DinnerSessionBuilderStub.h"
#import "OrderDTO.h"

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

- (void)testPostDinner{
  DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
  id dinnerSessionManager = [OCMockObject mockForClass:[DinnerSessionManager class]];
  dinnerTimeService.dinnerSessionManager = dinnerSessionManager;
  DinnerDTO *dinner = [DinnerDTO new];
  dinner.title = @"mockTitle";
  XCTestExpectation *expectation = [self expectationWithDescription:@"dinnerCallback"];

  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)( NSString *);
    [invocation getArgument: &passedBlock atIndex: 4];
    passedBlock([self mockPOSTDinnerResponse]);
  };

  [((DinnerSessionManager *)[[dinnerSessionManager stub] andDo:proxyBlock ]) POST:@"/dinners" parameters:@{@"title" : @"mockTitle"} success:OCMOCK_ANY failure:OCMOCK_ANY];
  [dinnerTimeService postDinner:dinner withCallback:^(DinnerDTO *dinnerDTO){
    XCTAssertEqualObjects(dinnerDTO, [self resultPOSTDinner]);
    [expectation fulfill];
  }];
  [dinnerSessionManager verify];
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testPostOrder{
    DinnerTimeService *dinnerTimeService = [DinnerTimeService new];
    id dinnerSessionManager = [OCMockObject mockForClass:[DinnerSessionManager class]];
    dinnerTimeService.dinnerSessionManager = dinnerSessionManager;
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
        void (^passedBlock)( NSString *);
        [invocation getArgument: &passedBlock atIndex: 4];
        passedBlock([self mockPOSTOrderResponse]);
    };

    XCTestExpectation *expectation = [self expectationWithDescription:@"callback expected"];

    [((DinnerSessionManager *)[[dinnerSessionManager stub] andDo:proxyBlock]) POST:@"/dinners/42/orders" parameters:@{@"order":@"testOrder"} success:OCMOCK_ANY failure:OCMOCK_ANY];
    [dinnerTimeService postOrder:@"testOrder" withDinnerId:42 withCallback:^(OrderDTO *dto) {
        XCTAssertEqualObjects(dto, [self resultPOSTOrder]);
        [expectation fulfill];
    }];
    [dinnerSessionManager verify];
    [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (NSArray *)mockResultOutputArray {
  DinnerDTO *dinner1 = [DinnerDTO new];
  dinner1.dinnerId = 1;
  dinner1.owned = YES;
  dinner1.owner = @"MockOwner";
  dinner1.title = @"MockTitle";
  OrderDTO *order1 = [OrderDTO new];
  order1.orderId = 1;
  order1.order = @"Order name";
  order1.owner = @"Test owner";
  order1.owned = YES;
  OrderDTO *order2 = [OrderDTO new];
  order2.orderId = 2;
  order2.order = @"Test order";
  order2.owner = @"Test owner 2";
  order2.owned = NO;
  dinner1.orders = (NSArray <OrderDTO> *) @[order1, order2];
  DinnerDTO *dinner2 = [DinnerDTO new];
  dinner2.dinnerId = 2;
  dinner2.owned = NO;
  dinner2.owner = @"MockOwner2";
  dinner2.title = @"MockTitle2";
  dinner2.orders = (NSArray <OrderDTO> *) @[];
  return @[dinner1, dinner2];
}

- (NSString *)mockResultJSONString {
  return @"{  "
          "   \"dinners\":[  "
          "      {  "
          "         \"dinnerId\":1,"
          "         \"title\":\"MockTitle\","
          "         \"owner\":\"MockOwner\","
          "         \"owned\":true,"
          "         \"orders\": ["
          "           {"
          "                \"orderId\": 1,"
          "                \"order\": \"Order name\","
          "                \"owner\": \"Test owner\","
          "                \"owned\": true"
          "            }"
          "          , {"
          "                    \"orderId\": 2,"
          "                    \"order\": \"Test order\","
          "                    \"owner\": \"Test owner 2\","
          "                    \"owned\": false"
          "                }]"
          "      },"
          "      {  "
          "         \"dinnerId\":2,"
          "         \"title\":\"MockTitle2\","
          "         \"owner\":\"MockOwner2\","
          "         \"owned\":false,"
          "         \"orders\":[]"
          "      }]"
          "}";
}

- (NSString *)mockPOSTOrderResponse{
    return @"{"
            "    \"orderId\": 42,"
            "    \"order\": \"Test title\","
            "    \"owned\": true,"
            "    \"owner\": \"Test user\""
            "}";
}

- (NSString *)mockPOSTDinnerResponse{
  return @"{"
          "    \"dinnerId\": 11,"
          "    \"title\": \"Test title\","
          "    \"owned\": true,"
          "    \"owner\": \"Test user\""
          "}";
}

- (OrderDTO *)resultPOSTOrder{
    OrderDTO *result = [OrderDTO new];
    result.orderId = 42;
    result.order = @"Test title";
    result.owned = YES;
    result.owner = @"Test user";
    return result;
}

- (DinnerDTO *)resultPOSTDinner{
  DinnerDTO *result = [DinnerDTO new];
  result.dinnerId = 11;
  result.title = @"Test title";
  result.owned = YES;
  result.owner = @"Test user";
  return result;
}

@end