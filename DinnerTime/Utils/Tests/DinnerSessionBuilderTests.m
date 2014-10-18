//
//  DinnerSessionBuilderTests.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 11/10/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DinnerSessionBuilder.h"
#import "DinnerSessionManager.h"

@interface DinnerSessionBuilderTests : XCTestCase

@end

@implementation DinnerSessionBuilderTests


- (void)testBuilderInstantiateDinnerSession{
  DinnerSessionBuilder *dinnerSessionBuilder = [DinnerSessionBuilder new];
  DinnerSessionManager *dinnerSessionManager = [dinnerSessionBuilder constructSessionManager];
  XCTAssertEqualObjects(dinnerSessionManager.sessionManager.baseURL, [NSURL URLWithString:@"https://192.168.1.126:3002"]);
  XCTAssertTrue([dinnerSessionManager.sessionManager.responseSerializer isKindOfClass:[AFHTTPResponseSerializer class]]);
  XCTAssertFalse([dinnerSessionManager.sessionManager.responseSerializer isKindOfClass:[AFJSONResponseSerializer class]]);
  XCTAssertTrue(dinnerSessionManager.sessionManager.securityPolicy.allowInvalidCertificates);
  XCTAssertNotNil(dinnerSessionManager.sessionManager.securityPolicy.pinnedCertificates);
}

@end
