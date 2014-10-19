//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginManager.h"
#import "GoogleSignInManagerSpy.h"
#import "LoginManagerDelegateSpy.h"
#import "DinnerTimeServiceSpy.h"
#import "GoogleSignInManagerStub.h"

@interface LoginManagerTests : XCTestCase
@end

@implementation LoginManagerTests {

}

- (void)testLoginManagerLaunchGoogleSignIn{
  GoogleSignInManagerSpy *googleSpy = [GoogleSignInManagerSpy new];
  LoginManager *loginManager = [[LoginManager alloc] initWithGoogleSignInManager:googleSpy withDinnerTimeService:nil];
  [loginManager signIn];
  XCTAssertTrue(googleSpy.signInCalled);
}

- (void)testLoginManagerAcceptsGoogleTokenAndPassItToDinnerTimeService {
  DinnerTimeServiceSpy *dinnerTimeServiceSpy = [DinnerTimeServiceSpy new];
  LoginManager *loginManager = [[LoginManager alloc] initWithGoogleSignInManager:nil withDinnerTimeService:dinnerTimeServiceSpy];
  id <GoogleSignInManagerDelegate> googleSignInDelegate = loginManager;
  [googleSignInDelegate googleSignInManagerAuthenticatedInGoogleWithToken:@"TestToken"];
  XCTAssertEqualObjects(dinnerTimeServiceSpy.token, @"TestToken");
}

- (void)testLoginManagerIsDelegateForGoogleSignInManager{
  GoogleSignInManager *googleSignInManager = [GoogleSignInManager new];
  LoginManager *loginManager = [[LoginManager alloc] initWithGoogleSignInManager:googleSignInManager withDinnerTimeService:nil];
  XCTAssertEqual(loginManager, googleSignInManager.delegate);
}

- (void)testLoginManagerCallsHisDelegate{
  LoginManager *loginManager = [LoginManager new];
  loginManager.dinnerTimeService = [DinnerTimeServiceSpy new];
  GoogleSignInManagerStub *googleSignInManagerStub = [GoogleSignInManagerStub new];
  googleSignInManagerStub.delegate = loginManager;
  loginManager.googleManger = googleSignInManagerStub;
  LoginManagerDelegateSpy *delegateSpy = [LoginManagerDelegateSpy new];
  loginManager.delegate = delegateSpy;
  [loginManager signIn];
  XCTAssertTrue(delegateSpy.wasCalled);
}

- (void)testLoginManagerLogout{
  LoginManager *loginManager = [LoginManager new];
  DinnerTimeServiceSpy *dinnerTimeServiceSpy = [DinnerTimeServiceSpy new];
  loginManager.dinnerTimeService = dinnerTimeServiceSpy;
  [loginManager logout];
  XCTAssertTrue(dinnerTimeServiceSpy.logoutCalled);
}

@end