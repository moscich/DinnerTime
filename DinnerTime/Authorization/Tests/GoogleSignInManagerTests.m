//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "GoogleSignInManager.h"
#import "GoogleSignInManagerDelegateSPY.h"


@interface GoogleSignInManagerTests : XCTestCase
@end

@implementation GoogleSignInManagerTests {

}

- (void)testLoginManagerImplementsGPPSignInDelegate{
  GoogleSignInManager *loginManager = [GoogleSignInManager new];
  XCTAssertTrue([loginManager conformsToProtocol:@protocol(GPPSignInDelegate)]);
}

- (void)testLoginManagerDelegateGoogleToken{
  GoogleSignInManager *loginManager = [GoogleSignInManager new];
  GoogleSignInManagerDelegateSPY *delegateSPY = [GoogleSignInManagerDelegateSPY new];
  loginManager.delegate = delegateSPY;
  id <GPPSignInDelegate> singInDelegate = loginManager;
  GTMOAuth2Authentication *authentication = [GTMOAuth2Authentication new];
  authentication.accessToken = @"TestToken";
  [singInDelegate finishedWithAuth:authentication error:nil];
  XCTAssertEqualObjects(delegateSPY.token, @"TestToken");
}

@end