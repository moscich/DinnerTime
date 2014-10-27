//
//  AppDelegateTests.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 27/10/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DinnerListViewController.h"

@interface AppDelegateTests : XCTestCase

@end

@implementation AppDelegateTests

- (void)testApplicationStartsWithProperControllersInNavigationStack {
  AppDelegate *appDelegate = [AppDelegate new];
  id partialAppDelegateMock = [OCMockObject partialMockForObject:appDelegate];
  id mockWindow = [OCMockObject niceMockForClass:[UIWindow class]];
  [[mockWindow expect] setRootViewController:[OCMArg checkWithBlock:^BOOL(id obj) {
    UINavigationController *nav = obj;
    LoginViewController *loginViewController = nav.viewControllers[0];
    DinnerListViewController *dinnerListViewController = nav.viewControllers[1];
    BOOL isDinnerManagerNotNil = loginViewController.dinnerManager != nil;
    BOOL isDinnerManagerProperlyInstantiated = loginViewController.dinnerManager == dinnerListViewController.dinnerManager;
    BOOL hasDinnerListHaveLoginManager = dinnerListViewController.loginManager == loginViewController.loginManager;
    return isDinnerManagerNotNil && isDinnerManagerProperlyInstantiated && hasDinnerListHaveLoginManager;
  }]];
  [[[partialAppDelegateMock stub] andReturn:mockWindow] window];
  [appDelegate application:nil didFinishLaunchingWithOptions:nil];
  [mockWindow verify];
}


@end