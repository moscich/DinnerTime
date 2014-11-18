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
#import "ControllerAssembly.h"
#import "DinnerTimeServiceAssembly.h"
#import "ModelAssembly.h"
#import "ApplicationAssembly.h"
#import "TyphoonPatcher.h"
#import <XCTest/XCTest.h>
#import <Typhoon/TyphoonBlockComponentFactory.h>

@interface LoginViewControllerTests : XCTestCase
@property(nonatomic, strong) LoginViewController *loginViewController;
@end

@implementation LoginViewControllerTests {

}

- (void)setUp {
  [super setUp];

  TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[[ApplicationAssembly assembly], [ModelAssembly assembly], [DinnerTimeServiceAssembly assembly], [ControllerAssembly assembly]]];
  self.loginViewController = [factory componentForType:[LoginViewController class]];
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

- (void)testPushDinnerListViewControllerWhenSuccessfulLogin {
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  TyphoonPatcher *patcher = [[TyphoonPatcher alloc] init];
  [patcher patchDefinitionWithSelector:@selector(registerDinnerListViewController) withObject:^id{
    return dinnerListViewController;
  }];
  [[self.loginViewController.assembly asFactory] attachPostProcessor:patcher];
  id partialLoginViewControllerMock = [OCMockObject partialMockForObject:self.loginViewController];
  id mockNavController = [OCMockObject mockForClass:[UINavigationController class]];
  [[mockNavController expect] pushViewController:[OCMArg checkWithBlock:^BOOL(id obj) {
    return obj == dinnerListViewController;
  }]                                    animated:YES];
  [[[partialLoginViewControllerMock stub] andReturn:mockNavController] navigationController];
  [self.loginViewController loginManagerLoginSuccessful];
  [mockNavController verify];

}

@end