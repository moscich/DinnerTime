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
#import <XCTest/XCTest.h>

@interface LoginViewControllerTests : XCTestCase
@property(nonatomic, strong) LoginViewController *loginViewController;
@end

@implementation LoginViewControllerTests {

}

- (void)setUp {
  [super setUp];
  self.loginViewController = [LoginViewController new];
}

- (void)testLoginViewControllerRespondToDelegateSelector{
  XCTAssertTrue([self.loginViewController respondsToSelector:@selector(loginManagerLoginSuccessful)]);
}

- (void)testLoginViewControllerInstantiateLoginManager{
  XCTAssertNotNil(self.loginViewController.loginManager);
}

- (void)testLoginViewControllerAsksForDinnersAfterViewDidLoad{
  DinnerManagerSpy *dinnerManagerSpy = [DinnerManagerSpy new];
  self.loginViewController.dinnerManager = dinnerManagerSpy;
  [self.loginViewController viewDidLoad];
  XCTAssertTrue(dinnerManagerSpy.getDinnersAsked);
}

- (void)testLoginViewControllerHasLoginView{
  XCTAssertTrue([self.loginViewController.view isKindOfClass:[LoginView class]]);
}

- (void)testLoginViewControllerHasProperViewsVisible{
  [self.loginViewController viewDidLoad];
  XCTAssertFalse(((LoginView *)self.loginViewController.view).activityIndicator.hidden);
  XCTAssertTrue([((LoginView *) self.loginViewController.view).activityIndicator isAnimating]);
  XCTAssertTrue(((LoginView *) self.loginViewController.view).signInButton.hidden);
}

- (void)testLoginViewControllerShowsLoginButtonWhenUnauthorised{
  self.loginViewController.dinnerManager = [[DinnerManagerStub alloc] initWithReturnType:DinnerServiceResult_Unauthorized];
  [self.loginViewController viewDidLoad];
  XCTAssertTrue(((LoginView *)self.loginViewController.view).activityIndicator.hidden);
  XCTAssertFalse(((LoginView *)self.loginViewController.view).signInButton.hidden);
}

- (void)testLoginViewControllerNavigateWhenSuccessfullyReceivedDinners{
  self.loginViewController.dinnerManager = [[DinnerManagerStub alloc] initWithReturnType:DinnerServiceResult_Success];
  id loginViewController1 = [OCMockObject partialMockForObject:self.loginViewController];
  id mockNavController = [OCMockObject mockForClass:[UINavigationController class]];
  [[[loginViewController1 stub] andReturn:mockNavController] navigationController];

  UIViewController* expectedPushedViewController = [OCMArg checkWithBlock:^BOOL(id obj) {
    return [obj isKindOfClass:[DinnerListViewController class]];
  }];

  [[mockNavController expect] pushViewController:expectedPushedViewController animated:YES];
  [self.loginViewController viewDidLoad];
  [mockNavController verify];
}

- (void)testLoginViewControllerIsLoginManagerDelegate{
  XCTAssertEqual(self.loginViewController.loginManager.delegate, self.loginViewController);
}

- (void)testLoginViewControllerInitsWithDinnerService{
  XCTAssertNotNil(self.loginViewController.loginManager.dinnerTimeService);
}

@end