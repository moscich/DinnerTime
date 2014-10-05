//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "LoginViewController.h"
#import <XCTest/XCTest.h>

@interface LoginViewControllerTests : XCTestCase
@end

@implementation LoginViewControllerTests {

}

- (void)testLoginViewControllerRespondToDelegateSelector{
  LoginViewController *loginViewController = [LoginViewController new];
  XCTAssertTrue([loginViewController respondsToSelector:@selector(loginManagerLoginSuccessful)]);
}

- (void)testLoginViewControllerInstantiateLoginManager{
  LoginViewController *loginViewController = [LoginViewController new];
  XCTAssertNotNil(loginViewController.loginManager);
}

- (void)testLoginViewControllerIsLoginManagerDelegate{
  LoginViewController *loginViewController = [LoginViewController new];
  XCTAssertEqual(loginViewController.loginManager.delegate, loginViewController);
}

//- (void)testLoginViewControllerPushDinnerListWhenLoginSuccessful{
//  id mockNavController = [OCMockObject mockForClass:[UINavigationController class]];
//  LoginViewController *loginViewController = [LoginViewController new];
//  id loginViewControllerMock = [OCMockObject partialMockForObject:loginViewController];
//  [[[loginViewControllerMock stub] andReturn:mockNavController] navigationController];
//  [loginViewController loginManagerLoginSuccessful];
//  [[mockNavController expect] pushViewController:[OCMArg any] animated:YES];
//}

@end