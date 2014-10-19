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

- (void)testLoginViewControllerInjectsDinnerTimeServiceToHisIstantiatedManagers{
  XCTAssertNotNil(self.loginViewController.loginManager);
  XCTAssertNotNil(self.loginViewController.dinnerManager);
  XCTAssertEqual(self.loginViewController.dinnerManager.dinnerTimeService, self.loginViewController.loginManager.dinnerTimeService);
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
  [self.loginViewController loadView];
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

- (void)testLoginViewControllerNavigateToDinnerListWithDinnerAndLoginManagerWhenSuccessfullyReceivedDinners{
  DinnerManagerStub *dinnerManagerStub = [[DinnerManagerStub alloc] initWithReturnType:DinnerServiceResult_Success];
  LoginManager *loginManager = [LoginManager new];
  self.loginViewController.dinnerManager = dinnerManagerStub;
  self.loginViewController.loginManager = loginManager;
  id loginViewController1 = [OCMockObject partialMockForObject:self.loginViewController];
  id mockNavController = [OCMockObject mockForClass:[UINavigationController class]];
  [[[loginViewController1 stub] andReturn:mockNavController] navigationController];

  NSArray *expectedPushedViewControllerArray = [OCMArg checkWithBlock:^BOOL(id obj) {
    if([obj isKindOfClass:[NSArray class]]){
      NSArray *array = obj;
      if(array.count == 1 && [[array firstObject] isKindOfClass:[DinnerListViewController class]]){
        DinnerListViewController *dinnerListViewController = [array firstObject];
        return dinnerListViewController.dinnerManager == dinnerManagerStub && dinnerListViewController.loginManager == loginManager;
      }
    }
      
    return NO;
  }];

  [[mockNavController expect] setViewControllers:expectedPushedViewControllerArray animated:YES];
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