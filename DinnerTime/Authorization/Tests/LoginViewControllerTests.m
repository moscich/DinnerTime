//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "LoginViewController.h"
#import "DinnerManager.h"
#import "DinnerManagerSpy.h"
#import "LoginView.h"
#import "DinnerManagerStub.h"
#import "OCMockObject.h"
#import "OCMStubRecorder.h"
#import "OCMArg.h"
#import "DinnerListViewController.h"
#import "DinnerSessionBuilder.h"
#import "DinnerTimeServiceImpl.h"
#import <XCTest/XCTest.h>
#import <Typhoon/TyphoonBlockComponentFactory.h>

@interface LoginViewControllerTests : XCTestCase
@property(nonatomic, strong) LoginViewController *loginViewController;
@end

@implementation LoginViewControllerTests {

}

- (void)setUp {
  [super setUp];
  DinnerTimeServiceImpl *dinnerTimeService = [[DinnerTimeServiceImpl alloc] initWithDinnerSessionBuilder:[DinnerSessionBuilder new]];
  DinnerManager *dinnerManager = [[DinnerManager alloc] initWithDinnerTimeService:dinnerTimeService];

  self.loginViewController = [[TyphoonBlockComponentFactory defaultFactory] componentForType:[LoginViewController class]];
}

- (void)testLoginViewControllerRespondToDelegateSelector {
  XCTAssertTrue([self.loginViewController respondsToSelector:@
          selector(loginManagerLoginSuccessful)]);
}

- (void)testLoginViewControllerInjectsDinnerTimeServiceToHisIstantiatedManagers {
  XCTAssertNotNil(self.loginViewController.loginManager);
  XCTAssertNotNil(self.loginViewController.dinnerManager);
  XCTAssertEqual(self.loginViewController.dinnerManager.dinnerTimeService, self.loginViewController.loginManager.dinnerTimeService);
}

- (void)testLoginViewControllerHasLoginView {
  XCTAssertTrue([self.loginViewController.view isKindOfClass:[LoginView class]]);
}

- (void)testLoginViewControllerHasProperViewsVisible {
  [self.loginViewController loadView];
  XCTAssertFalse([((LoginView *) self.loginViewController.view).activityIndicator isAnimating]);
  XCTAssertFalse(((LoginView *) self.loginViewController.view).signInButton.hidden);
}

- (void)testLoginViewControllerShowsLoginButtonWhenUnauthorised {
  self.loginViewController.dinnerManager = [[DinnerManagerStub alloc] initWithReturnType:DinnerServiceResult_Unauthorized];
  [self.loginViewController viewDidLoad];
  XCTAssertFalse(((LoginView *) self.loginViewController.view).signInButton.hidden);
}

- (void)testLoginViewControllerIsLoginManagerDelegate {
  XCTAssertEqual(self.loginViewController.loginManager.delegate, self.loginViewController);
}

- (void)testLoginViewControllerInitsWithDinnerService {
  XCTAssertNotNil(self.loginViewController.loginManager.dinnerTimeService);
}

@end