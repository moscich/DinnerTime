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
#import "OCObserverMockObject.h"
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
    return [nav.viewControllers[0] isKindOfClass:[LoginViewController class]] && [nav.viewControllers[1] isKindOfClass:[DinnerListViewController class]];
  }]];
  [[[partialAppDelegateMock stub] andReturn:mockWindow] window];
  [appDelegate application:nil didFinishLaunchingWithOptions:nil];
}


@end
