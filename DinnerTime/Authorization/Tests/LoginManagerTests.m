//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginManager.h"
#import "GoogleSignInManagerSpy.h"
#import "DinnerTimeLoginManagerSPY.h"
#import "LoginManagerDelegateSpy.h"

@interface LoginManagerTests : XCTestCase
@end

@implementation LoginManagerTests {

}

- (void)testLoginManagerLaunchGoogleSignIn{
  GoogleSignInManagerSpy *googleSpy = [GoogleSignInManagerSpy new];
  LoginManager *loginManager = [[LoginManager alloc] initWithGoogleSignInManager:googleSpy withDinnerTimeLoginManager:nil];
  [loginManager signIn];
  XCTAssertTrue(googleSpy.signInCalled);
}

- (void)testLoginManagerAcceptsGoogleTokenAndPassItToDinnerTimeService {
  DinnerTimeLoginManagerSPY *dinnerTimeLoginManagerSPY = [DinnerTimeLoginManagerSPY new];
  LoginManager *loginManager = [[LoginManager alloc] initWithGoogleSignInManager:nil withDinnerTimeLoginManager:dinnerTimeLoginManagerSPY];
  id <GoogleSignInManagerDelegate> googleSignInDelegate = loginManager;
  [googleSignInDelegate googleSignInManagerAuthenticatedInGoogleWithToken:@"TestToken"];
  XCTAssertEqualObjects(dinnerTimeLoginManagerSPY.token, @"TestToken");
}

- (void)testLoginManagerIsDelegateForDinnerTimeLoginManager{
  DinnerTimeLoginManager *dinnerTimeLoginManager = [DinnerTimeLoginManager new];
  LoginManager *loginManager = [[LoginManager alloc] initWithGoogleSignInManager:nil withDinnerTimeLoginManager:dinnerTimeLoginManager];
  XCTAssertEqual(loginManager, dinnerTimeLoginManager.delegate);
}

- (void)testLoginManagerIsDelegateForGoogleSignInManager{
  GoogleSignInManager *googleSignInManager = [GoogleSignInManager new];
  LoginManager *loginManager = [[LoginManager alloc] initWithGoogleSignInManager:googleSignInManager withDinnerTimeLoginManager:nil];
  XCTAssertEqual(loginManager, googleSignInManager.delegate);
}

- (void)testLoginManagerCallsHisDelegate{
  LoginManager *loginManager = [LoginManager new];
  LoginManagerDelegateSpy *delegateSpy = [LoginManagerDelegateSpy new];
  loginManager.delegate = delegateSpy;
  [loginManager dinnerTimeLoginManagerLoginSuccessfully];
  XCTAssertTrue(delegateSpy.wasCalled);
}

@end