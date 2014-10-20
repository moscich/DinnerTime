//
//  AddDinnerViewControllerTests.m
//  DinnerTime
//
//  Created by Marek Mościchowski on 20/10/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMockObject.h>
#import "AddDinnerViewController.h"

@interface AddDinnerViewControllerTests : XCTestCase

@end

@implementation AddDinnerViewControllerTests

- (void)testItsViewHasProperSubviews{
    AddDinnerViewController *addDinnerViewController = [AddDinnerViewController new];
    addDinnerViewController.view;
    XCTAssertNotNil(addDinnerViewController.titleTextField);
    XCTAssertNotNil(addDinnerViewController.textView);
    XCTAssertNotNil(addDinnerViewController.sendButton);
    XCTAssertFalse(addDinnerViewController.sendButton.enabled);
}

- (void)testPopsWhenCancel{
    AddDinnerViewController *addDinnerViewController = [AddDinnerViewController new];
    id partialAddDinnerViewController = [OCMockObject partialMockForObject:addDinnerViewController];
    [[partialAddDinnerViewController expect] dismissViewControllerAnimated:YES completion:nil];
    [addDinnerViewController cancelButtonTapped];
    [partialAddDinnerViewController verify];
}

@end
