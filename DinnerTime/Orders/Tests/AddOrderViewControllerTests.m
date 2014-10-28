//
//  AddOrderViewControllerTests.m
//  DinnerTime
//
//  Created by Marek Mościchowski on 28/10/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "AddOrderViewController.h"

@interface AddOrderViewControllerTests : XCTestCase

@end

@implementation AddOrderViewControllerTests

- (void)testViewProperlyInstantiated {
    AddOrderViewController *addOrderViewController = [AddOrderViewController new];
    [addOrderViewController view];
    XCTAssertNotNil(addOrderViewController.orderTitleTextField);
    XCTAssertNotNil(addOrderViewController.sendButton);
    XCTAssertFalse(addOrderViewController.sendButton.enabled);
    XCTAssertEqual(addOrderViewController.orderTitleTextField.delegate, addOrderViewController);
}

- (void)testHideControllerWhenCancelTapped{
    AddOrderViewController *addOrderViewController = [AddOrderViewController new];
    id partialMock = [OCMockObject partialMockForObject:addOrderViewController];
    [[partialMock expect] dismissViewControllerAnimated:YES completion:nil];
    [addOrderViewController cancelButtonTapped];
    [partialMock verify];
}

- (void)testRegisterTextDidChange {
    id mockTextField = [OCMockObject mockForClass:[UITextField class]];
    AddOrderViewController *addOrderViewController = [AddOrderViewController new];
    addOrderViewController.orderTitleTextField = mockTextField;
    [[mockTextField expect] addTarget:addOrderViewController action:@selector(titleTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [addOrderViewController viewDidLoad];
    [mockTextField verify];
}

- (void)testControllerSetsSendButtonEnableState{
    AddOrderViewController *addOrderViewController = [AddOrderViewController new];
    [addOrderViewController view];
    UITextField *field = [UITextField new];
    field.text = @"test";
    [addOrderViewController titleTextFieldChanged:field];
    XCTAssertTrue(addOrderViewController.sendButton.enabled);
    field.text = @"";
    [addOrderViewController titleTextFieldChanged:field];
    XCTAssertFalse(addOrderViewController.sendButton.enabled);
}

- (void)testAddOrderSentToDelegateAndDismiss{
    AddOrderViewController *addOrderViewController = [AddOrderViewController new];
    id partialMock = [OCMockObject partialMockForObject:addOrderViewController];
    [[partialMock expect] dismissViewControllerAnimated:YES completion:nil];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(AddOrderViewControllerDelegate)];
    addOrderViewController.delegate = mockDelegate;
    [[mockDelegate expect] addNewOrderNamed:@"test"];
    UITextField *field = [UITextField new];
    field.text = @"test";
    addOrderViewController.orderTitleTextField = field;
    [addOrderViewController sendButtonTapped];
    [mockDelegate verify];
    [partialMock verify];
}

@end
