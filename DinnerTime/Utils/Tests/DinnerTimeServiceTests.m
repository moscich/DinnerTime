//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DinnerTimeServiceImpl.h"
#import "UICKeyChainStore.h"
#import "DinnerDTO.h"
#import "DinnerSessionBuilder.h"
#import "DinnerSessionManager.h"
#import "DinnerSessionManagerSpy.h"
#import "DinnerSessionBuilderStub.h"
#import "OrderDTO.h"
#import "ApplicationAssembly.h"
#import "ModelAssembly.h"
#import "DinnerTimeServiceAssembly.h"
#import "DinnerTimeService.h"
#import <Typhoon/Typhoon.h>

@interface DinnerTimeServiceTests : XCTestCase

@property(nonatomic, strong) DinnerTimeServiceImpl *dinnerTimeService;

@end

@implementation DinnerTimeServiceTests {

}

- (void)setUp {
  [UICKeyChainStore setString:@"mockSessionId" forKey:@"session_id"];
  TyphoonComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[[ApplicationAssembly assembly], [ModelAssembly assembly], [DinnerTimeServiceAssembly assembly]]];
  self.dinnerTimeService = [factory componentForType:@protocol(DinnerTimeService)];
}

- (void)testBuilderInstantiateDinnerSession{
  DinnerSessionManager *dinnerSessionManager = self.dinnerTimeService.dinnerSessionManager;
  XCTAssertEqualObjects(dinnerSessionManager.sessionManager.baseURL, [NSURL URLWithString:@"https://192.168.1.126:3002"]);
  XCTAssertTrue([dinnerSessionManager.sessionManager.responseSerializer isKindOfClass:[AFHTTPResponseSerializer class]]);
  XCTAssertFalse([dinnerSessionManager.sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]);
  XCTAssertTrue(dinnerSessionManager.sessionManager.securityPolicy.allowInvalidCertificates);
  XCTAssertNotNil(dinnerSessionManager.sessionManager.securityPolicy.pinnedCertificates);
}

- (void)testDinnerTimeServiceLogin {
  NSString *sessionJSON = @"{\"sessionId\":\"testSessionId\"}";
  DinnerSessionManagerSpy *dinnerSessionManagerSpy = [[DinnerSessionManagerSpy alloc] initWithSessionJSON:sessionJSON];
  self.dinnerTimeService.dinnerSessionManager = dinnerSessionManagerSpy;
  XCTestExpectation *expectation = [self expectationWithDescription:@"callback"];
  [self.dinnerTimeService loginWithToken:@"TestToken" withCallback:^(NSString *sessionId) {
    XCTAssertEqualObjects(sessionId, @"testSessionId");
    [expectation fulfill];
  }];
  XCTAssertEqualObjects(dinnerSessionManagerSpy.parameters[@"token"], @"TestToken");
  XCTAssertEqualObjects(dinnerSessionManagerSpy.postCalledAddress, @"/login");
  XCTAssertEqualObjects(dinnerSessionManagerSpy.sessionId, @"testSessionId");
  XCTAssertEqualObjects([UICKeyChainStore stringForKey:@"session_id"], @"testSessionId");
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testDinnerServiceSetSessionInHeader {
  [self.dinnerTimeService getDinners:^(NSArray *array) {

  }                     failure:^(DinnerServiceResultType type) {

  }];

  XCTAssertEqualObjects(self.dinnerTimeService.dinnerSessionManager.sessionId, @"mockSessionId");
}

- (void)testGetDinnersSucceed {
  DinnerSessionManagerSpy *dinnerSessionManagerSpy = [[DinnerSessionManagerSpy alloc] initWithDinnerJSON:[self mockResultJSONString]];
  self.dinnerTimeService.dinnerSessionManager = dinnerSessionManagerSpy;
  XCTestExpectation *successExpectation = [self expectationWithDescription:@"successCallback"];
  [self.dinnerTimeService getDinners:^(NSArray *dinnerArray) {
    NSArray *array = [self mockResultOutputArray];
    XCTAssertEqualObjects(dinnerArray, array);
    [successExpectation fulfill];
  }                     failure:^(DinnerServiceResultType type) {

  }];
  XCTAssertEqualObjects(dinnerSessionManagerSpy.getCalledAddress, @"/dinners");
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testGetDinnersWhenUnauthorized {
  DinnerSessionManagerSpy *dinnerSessionManagerSpy = [[DinnerSessionManagerSpy alloc] initWithResultType:DinnerServiceResult_Unauthorized];
  self.dinnerTimeService.dinnerSessionManager = dinnerSessionManagerSpy;
  XCTestExpectation *failureExpectation = [self expectationWithDescription:@"failureCallback"];
  [self.dinnerTimeService getDinners:nil failure:^(DinnerServiceResultType type) {
    XCTAssertEqual(type, DinnerServiceResult_Unauthorized);
    [failureExpectation fulfill];
  }];
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testLogout {
  DinnerSessionManagerSpy *dinnerSessionManagerSpy = [DinnerSessionManagerSpy new];
  self.dinnerTimeService.dinnerSessionManager = dinnerSessionManagerSpy;
  XCTestExpectation *expectation = [self expectationWithDescription:@"logoutCallback"];
  [self.dinnerTimeService logout:^(DinnerServiceResultType type) {
    [expectation fulfill];
  }];
  XCTAssertEqualObjects(dinnerSessionManagerSpy.postCalledAddress, @"/logout");
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testPostDinner {
  id dinnerSessionManager = [OCMockObject mockForClass:[DinnerSessionManager class]];
  self.dinnerTimeService.dinnerSessionManager = dinnerSessionManager;
  DinnerDTO *dinner = [DinnerDTO new];
  dinner.title = @"mockTitle";
  dinner.details = @"mockSummary";
  XCTestExpectation *expectation = [self expectationWithDescription:@"dinnerCallback"];

  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(NSString *);
    [invocation getArgument:&passedBlock atIndex:4];
    passedBlock([self mockPOSTDinnerResponse]);
  };

  [((DinnerSessionManager *) [[dinnerSessionManager stub] andDo:proxyBlock]) POST:@"/dinners" parameters:@{@"title" : @"mockTitle", @"details" : @"mockSummary"} success:OCMOCK_ANY failure:OCMOCK_ANY];
  [self.dinnerTimeService postDinner:dinner withCallback:^(DinnerDTO *dinnerDTO){
    XCTAssertEqualObjects(dinnerDTO, [self resultPOSTDinner]);
    [expectation fulfill];
  }];
  [dinnerSessionManager verify];
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testPostOrder {
  DinnerTimeServiceImpl *dinnerTimeService = [DinnerTimeServiceImpl new];
  id dinnerSessionManager = [OCMockObject mockForClass:[DinnerSessionManager class]];
  dinnerTimeService.dinnerSessionManager = dinnerSessionManager;
  void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
    void (^passedBlock)(NSString *);
    [invocation getArgument:&passedBlock atIndex:4];
    passedBlock([self mockPOSTOrderResponse]);
  };

  XCTestExpectation *expectation = [self expectationWithDescription:@"callback expected"];

  [((DinnerSessionManager *) [[dinnerSessionManager stub] andDo:proxyBlock]) POST:@"/dinners/42/orders" parameters:@{@"order" : @"testOrder"} success:OCMOCK_ANY failure:OCMOCK_ANY];
  [dinnerTimeService postOrder:@"testOrder" withDinnerId:42 withCallback:^(OrderDTO *dto) {
    XCTAssertEqualObjects(dto, [self resultPOSTOrder]);
    [expectation fulfill];
  }];
  [dinnerSessionManager verify];
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testPutOrder {
  id dinnerSessionManager = [OCMockObject mockForClass:[DinnerSessionManager class]];
  self.dinnerTimeService.dinnerSessionManager = dinnerSessionManager;
  [((DinnerSessionManager *)[dinnerSessionManager expect]) PUT:@"dinners/orders/24" parameters:@{@"completed":@YES} success:OCMOCK_ANY failure:OCMOCK_ANY];
  [self.dinnerTimeService changeOrderWithId:@24 toPaid:@YES];
  [dinnerSessionManager verify];
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
          "         \"details\":\"mockSummary\","
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
          "         \"details\":\"mockSummary\","
          "         \"owned\":false,"
          "         \"orders\":[]"
          "      }]"
          "}";
}

- (NSString *)mockPOSTOrderResponse {
  return @"{"
          "    \"orderId\": 42,"
          "    \"order\": \"Test title\","
          "    \"owned\": true,"
          "    \"owner\": \"Test user\""
          "}";
}

- (NSString *)mockPOSTDinnerResponse {
  return @"{"
          "    \"dinnerId\": 11,"
          "    \"title\": \"Test title\","
          "    \"details\":\"mockSummary\","
          "    \"owned\": true,"
          "    \"owner\": \"Test user\""
          "}";
}

- (OrderDTO *)resultPOSTOrder {
  OrderDTO *result = [OrderDTO new];
  result.orderId = 42;
  result.order = @"Test title";
  result.owned = YES;
  result.owner = @"Test user";
  return result;
}

- (DinnerDTO *)resultPOSTDinner {
  DinnerDTO *result = [DinnerDTO new];
  result.dinnerId = 11;
  result.title = @"Test title";
  result.details = @"mockSummary";
  result.owned = YES;
  result.owner = @"Test user";
  return result;
}

@end