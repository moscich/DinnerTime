//
//  DinnerWebSocketManagerTests.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 23/10/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DinnerWebSocketManager.h"
#import "DinnerDTO.h"
#import "OCMockObject.h"

@interface DinnerWebSocketManagerTests : XCTestCase

@end

@implementation DinnerWebSocketManagerTests


- (void)testHasSocketRocketWebSocketInstantiated{
  DinnerWebSocketManager *socketManager = [DinnerWebSocketManager new];
  XCTAssertEqualObjects(socketManager.webSocket.url.absoluteString,@"wss://192.168.1.126:8001");
  XCTAssertEqual(socketManager.webSocket.delegate,socketManager);
}

- (void)testTranslatesAndSendDinnersToDelegate{
  DinnerWebSocketManager *socketManager = [DinnerWebSocketManager new];
  id delegate = [OCMockObject mockForProtocol:@protocol(DinnerWebSocketManagerDelegate)];
  [[delegate expect] webSocketReceivedDinners:[self mockResultOutputArray]];
  socketManager.delegate = delegate;
  [socketManager webSocket:socketManager.webSocket didReceiveMessage:[self mockResultJSONString]];
  [delegate verify];
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
