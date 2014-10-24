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

// REMOVED SSL
//- (void)testHasSocketRocketWebSocketInstantiated{
//  DinnerWebSocketManager *socketManager = [DinnerWebSocketManager new];
//  XCTAssertEqualObjects(socketManager.webSocket.url.absoluteString,@"wss://192.168.1.126:8001");
//  XCTAssertEqual(socketManager.webSocket.delegate,socketManager);
//}

- (void)testTranslatesAndSendUpdateToDelegate{
  DinnerWebSocketManager *socketManager = [DinnerWebSocketManager new];
  id delegate = [OCMockObject mockForProtocol:@protocol(DinnerWebSocketManagerDelegate)];
  [[delegate expect] webSocketReceivedDinnerUpdate:@(42)];
  socketManager.delegate = delegate;
  [socketManager webSocket:socketManager.webSocket didReceiveMessage:@"{\"dinnerId\":42}"];
  [delegate verify];
}

@end
