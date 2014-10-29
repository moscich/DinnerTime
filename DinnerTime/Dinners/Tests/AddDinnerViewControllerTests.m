//
//  AddDinnerViewControllerTests.m
//  DinnerTime
//
//  Created by Marek Mościchowski on 20/10/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "AddDinnerViewController.h"
#import "DinnerDTO.h"

@interface AddDinnerViewControllerTests : XCTestCase

@end

@implementation AddDinnerViewControllerTests

- (void)testItsViewHasProperSubviews {
  AddDinnerViewController *addDinnerViewController = [AddDinnerViewController new];
  addDinnerViewController.view;
  XCTAssertNotNil(addDinnerViewController.titleTextField);
  XCTAssertNotNil(addDinnerViewController.detailTextView);
  XCTAssertEqual(addDinnerViewController.detailTextView.delegate, addDinnerViewController);
  XCTAssertNotNil(addDinnerViewController.sendButton);
  XCTAssertFalse(addDinnerViewController.sendButton.enabled);
}

- (void)testPopsWhenCancel {
  AddDinnerViewController *addDinnerViewController = [AddDinnerViewController new];
  id partialAddDinnerViewController = [OCMockObject partialMockForObject:addDinnerViewController];
  [[partialAddDinnerViewController expect] dismissViewControllerAnimated:YES completion:nil];
  [addDinnerViewController cancelButtonTapped];
  [partialAddDinnerViewController verify];
}

- (void)testControlsEnableStateOfSendButtonAccordingToTextInInputFields {
  AddDinnerViewController *addDinnerViewController = [AddDinnerViewController new];
  addDinnerViewController.view;
  addDinnerViewController.titleTextField.text = @"";
  addDinnerViewController.detailTextView.text = @"";
  XCTAssertFalse(addDinnerViewController.sendButton.enabled);
  addDinnerViewController.titleTextField.text = @"";
  addDinnerViewController.detailTextView.text = @"f";
  [addDinnerViewController textViewDidChange:addDinnerViewController.detailTextView];
  XCTAssertFalse(addDinnerViewController.sendButton.enabled);
  addDinnerViewController.titleTextField.text = @"";
  addDinnerViewController.detailTextView.text = @"";
  [addDinnerViewController textViewDidChange:addDinnerViewController.detailTextView];
  XCTAssertFalse(addDinnerViewController.sendButton.enabled);
  addDinnerViewController.titleTextField.text = @"f";
  addDinnerViewController.detailTextView.text = @"";
  [addDinnerViewController titleFieldDidChange:addDinnerViewController.titleTextField];
  XCTAssertFalse(addDinnerViewController.sendButton.enabled);
  addDinnerViewController.titleTextField.text = @"";
  addDinnerViewController.detailTextView.text = @"";
  [addDinnerViewController titleFieldDidChange:addDinnerViewController.titleTextField];
  XCTAssertFalse(addDinnerViewController.sendButton.enabled);
  addDinnerViewController.titleTextField.text = @"f";
  addDinnerViewController.detailTextView.text = @"f";
  [addDinnerViewController titleFieldDidChange:addDinnerViewController.titleTextField];
  [addDinnerViewController textViewDidChange:addDinnerViewController.detailTextView];
  XCTAssertTrue(addDinnerViewController.sendButton.enabled);
}

- (void)testRegisterTextDidChange {
  id mockTextField = [OCMockObject mockForClass:[UITextField class]];
  AddDinnerViewController *addDinnerViewController = [AddDinnerViewController new];
  addDinnerViewController.titleTextField = mockTextField;
  [[mockTextField expect] addTarget:addDinnerViewController action:@selector(titleFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
  [addDinnerViewController viewDidLoad];
  [mockTextField verify];
}

- (void)testSendButtonReturnsAndCallsItsDelegate {
  id mockDelegate = [OCMockObject mockForProtocol:@protocol(AddDinnerViewControllerDelegate)];
  AddDinnerViewController *addDinnerViewController = [AddDinnerViewController new];
  addDinnerViewController.delegate = mockDelegate;
  addDinnerViewController.view;
  addDinnerViewController.titleTextField.text = @"mockText";
  addDinnerViewController.detailTextView.text = @"mockDetails";
  id addDinnerPartialMock = [OCMockObject partialMockForObject:addDinnerViewController];
  [[addDinnerPartialMock expect] dismissViewControllerAnimated:YES completion:nil];
  id target = [addDinnerViewController.sendButton targetForAction:@selector(sendButtonTapped:) withSender:addDinnerViewController.sendButton];
  XCTAssertEqual(addDinnerViewController, target);
  [[mockDelegate expect] addDinnerViewControllerCreatedDinner:[OCMArg checkWithBlock:^BOOL(id obj) {
    if ([obj isKindOfClass:[DinnerDTO class]]) {
      DinnerDTO *dinner = obj;
      return [dinner.title isEqualToString:addDinnerViewController.titleTextField.text] && [addDinnerViewController.detailTextView.text isEqualToString:dinner.details];
    }
    return NO;
  }]];
  [addDinnerViewController sendButtonTapped:addDinnerViewController.sendButton];
  [mockDelegate verify];
  [addDinnerPartialMock verify];
}

@end
