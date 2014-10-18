//
//  DinnerSessionManagerTests.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 10/10/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMArg.h>
#import "DinnerSessionManager.h"
#import "HttpSessionManagerSpy.h"
#import "OCMockObject.h"
#import "OCMStubRecorder.h"
#import "AFHTTPRequestOperationManager.h"

@interface DinnerSessionManagerTests : XCTestCase

@end

@implementation DinnerSessionManagerTests


- (void)testDinnerSessionManagerProperlyInstantiateSessionManager{
  HttpSessionManagerSpy *sessionManagerSpy = [HttpSessionManagerSpy new];
  DinnerSessionManager *dinnerSessionManager = [[DinnerSessionManager alloc] initWithSessionManager:sessionManagerSpy];
  XCTAssertTrue([dinnerSessionManager.sessionManager.responseSerializer isKindOfClass:[AFHTTPResponseSerializer class]]);
}

- (void)testDinnerSessionManagerTranslatesResponseObjectToJSON{
  DinnerSessionManager *dinnerSessionManager = [DinnerSessionManager new];
  dinnerSessionManager.sessionManager = [[HttpSessionManagerSpy alloc] initWithResultData:[self mockResultInputJSONData]];
  XCTestExpectation *callbackExpectation = [self expectationWithDescription:@"callbackExpectation"];
  [dinnerSessionManager GET:@"/dinners" parameters:@{@"mockKey":@"mockValue"} success:^(NSString *responseJSON){
    [callbackExpectation fulfill];
    XCTAssertEqualObjects(responseJSON, [self mockResultJSONString]);
  } failure:nil];
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testDinnerSessionManagerAddSessionToHeaders{
  id mockSessionManager = [OCMockObject niceMockForClass:[AFHTTPSessionManager class]];
  id mockRequestSerializer = [OCMockObject mockForClass:[AFHTTPRequestSerializer class]];
  [[[mockSessionManager stub] andReturn:mockRequestSerializer] requestSerializer];
  [[mockRequestSerializer expect] setValue:@"mockSessionId" forHTTPHeaderField:@"session_id"];
  DinnerSessionManager *dinnerSessionManager = [[DinnerSessionManager alloc] initWithSessionManager:mockSessionManager];
  dinnerSessionManager.sessionId = @"mockSessionId";
  [dinnerSessionManager GET:nil parameters:nil success:nil failure:nil];
  [mockRequestSerializer verify];
  [[mockRequestSerializer expect] setValue:@"mockSessionId" forHTTPHeaderField:@"session_id"];
  [dinnerSessionManager POST:nil parameters:nil success:nil failure:nil];
  [mockRequestSerializer verify];
}

- (void)testDinnerSessionManagerPOST{
  HttpSessionManagerSpy *sessionManagerSpy = [[HttpSessionManagerSpy alloc] initWithResultData:[self mockPostJSONData]];
  DinnerSessionManager *dinnerSessionManager = [[DinnerSessionManager alloc] initWithSessionManager:sessionManagerSpy];
  XCTestExpectation *callbackExpectation = [self expectationWithDescription:@"callbackExpectation"];
  [dinnerSessionManager POST:@"/login" parameters:@{@"param1":@"value1"} success:^(NSString *string) {
    [callbackExpectation fulfill];
    XCTAssertEqualObjects(string, [self mockPostJSONString]);
  } failure:^(NSError *error) {

  }];
  XCTAssertEqualObjects(sessionManagerSpy.calledAddress,@"/login");
  XCTAssertEqualObjects(sessionManagerSpy.parameters,@{@"param1":@"value1"});
  [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (NSData *)mockResultInputJSONData {
  return [[self mockResultJSONString] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)mockPostJSONData{
  return [[self mockPostJSONString] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)mockPostJSONString{
  return @"{\"sessionId\":\"mock_session\"}";
}

- (NSString *)mockResultJSONString {
  NSString *json = @"{  "
          "   \"dinners\":[  "
          "      {  "
          "         \"dinnerId\":1,"
          "         \"title\":\"Nowy Dinner\","
          "         \"owner\":\"M Dupa\","
          "         \"owned\":true"
          "      },"
          "      {  "
          "         \"dinnerId\":3,"
          "         \"title\":\"Nowy order\","
          "         \"owner\":\"M Dupa\","
          "         \"owned\":true"
          "      },"
          "      {  "
          "         \"dinnerId\":4,"
          "         \"title\":\"Cos zupelnie innego\","
          "         \"owner\":\"Marek Mościchowski\","
          "         \"owned\":false"
          "      }"
          "   ]"
          "}";
  return json;
}

@end
