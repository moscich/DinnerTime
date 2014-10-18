//
//  DinnerListViewControllerTests.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 18/10/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DinnerListViewController.h"

@interface DinnerListViewControllerTests : XCTestCase

@end

@implementation DinnerListViewControllerTests

- (void)testDinnerManagerHasTableViewProperlyInstantiated{
  DinnerListViewController *dinnerListViewController = [DinnerListViewController new];
  dinnerListViewController.dinnerManager = [DinnerManager new];
  dinnerListViewController.view;
  XCTAssertNotNil(dinnerListViewController.tableView.dataSource);
  XCTAssertEqual(dinnerListViewController.tableView.dataSource,dinnerListViewController.dinnerManager);
}

@end
