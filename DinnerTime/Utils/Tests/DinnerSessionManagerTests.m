//
//  DinnerSessionManagerTests.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 10/10/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DinnerSessionManager.h"
#import "HttpSessionManagerSpy.h"
#import "OCMockObject.h"
#import "OCMStubRecorder.h"

@interface DinnerSessionManagerTests : XCTestCase

@end

@implementation DinnerSessionManagerTests


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

- (void)testDinnerSessionManagerProperlyInstantiateSessionManager{
  HttpSessionManagerSpy *sessionManagerSpy = [HttpSessionManagerSpy new];
  DinnerSessionManager *dinnerSessionManager = [[DinnerSessionManager alloc] initWithSessionManager:sessionManagerSpy];
  XCTAssertTrue([dinnerSessionManager.sessionManager.responseSerializer isKindOfClass:[AFHTTPResponseSerializer class]]);
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
}

- (NSData *)mockResultInputJSONData {
  NSString *json = [self mockResultJSONString];

  return [json dataUsingEncoding:NSUTF8StringEncoding];
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