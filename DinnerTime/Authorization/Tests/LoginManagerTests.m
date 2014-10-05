//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginManager.h"
#import "GoogleSignInManagerSpy.h"

@interface LoginManagerTests : XCTestCase
@end

@implementation LoginManagerTests {

}

- (void)testLoginManagerLaunchGoogleSignIn{
  GoogleSignInManagerSpy *googleSpy = [GoogleSignInManagerSpy new];
  LoginManager *loginManager = [[LoginManager alloc] initWithGoogleSignInManager:googleSpy];
  [loginManager signIn];
  XCTAssertTrue(googleSpy.signInCalled);
}

@end