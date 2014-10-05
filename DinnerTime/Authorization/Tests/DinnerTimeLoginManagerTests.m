//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DinnerTimeLoginManager.h"
#import "DinnerTimeService.h"
#import "DinnerTimeServiceSpy.h"
#import "DinnerTimeLoginManagerDelegateSpy.h"

@interface DinnerTimeLoginManagerTests : XCTestCase
@end

@implementation DinnerTimeLoginManagerTests {

}

- (void)testLoginManagerInitsDinnerTimeService{
  DinnerTimeLoginManager *loginManager = [DinnerTimeLoginManager new];
  XCTAssertTrue(loginManager.dinnerTimeService);
}

- (void)testLoginManagerCallsDinnerTimeService{
  DinnerTimeLoginManager *loginManager = [DinnerTimeLoginManager new];
  DinnerTimeServiceSpy *dinnerTimeServiceSpy = [DinnerTimeServiceSpy new];
  loginManager.dinnerTimeService = dinnerTimeServiceSpy;
  DinnerTimeLoginManagerDelegateSpy *delegateSpy = [DinnerTimeLoginManagerDelegateSpy new];
  loginManager.delegate = delegateSpy;
  [loginManager signInWithToken:@"testToken"];
  XCTAssertEqualObjects(dinnerTimeServiceSpy.token, @"testToken");
  XCTAssertTrue(delegateSpy.wasCalled);
}

@end