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
#import <Typhoon/Typhoon.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DinnerListViewController.h"
#import "ApplicationAssembly.h"
#import "ControllerAssembly.h"
#import "ModelAssembly.h"
#import "DinnerTimeServiceAssembly.h"

@interface AppDelegateTests : XCTestCase

@end

@implementation AppDelegateTests

- (void)testApplicationStartsWithProperControllersInNavigationStack {
  TyphoonComponentFactory * factory = [TyphoonBlockComponentFactory defaultFactory];
  AppDelegate *appDelegate = [factory componentForType:[AppDelegate class]];
  UINavigationController *navigationController = (UINavigationController *) appDelegate.window.rootViewController;
  XCTAssertNotNil(navigationController);
    LoginViewController *loginViewController = navigationController.viewControllers[0];
    DinnerListViewController *dinnerListViewController = navigationController.viewControllers[1];
    XCTAssertNotNil(loginViewController);
    XCTAssertNotNil(dinnerListViewController);
    XCTAssertNotNil(loginViewController.dinnerManager);
    XCTAssertNotNil(dinnerListViewController.dinnerManager);
    XCTAssertEqual(dinnerListViewController.dinnerManager, loginViewController.dinnerManager);
    XCTAssertNotNil(loginViewController.loginManager);
    XCTAssertNotNil(dinnerListViewController.loginManager);
    XCTAssertEqual(dinnerListViewController.loginManager, loginViewController.loginManager);
}

@end
