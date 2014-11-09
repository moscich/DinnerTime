//
//  OrderCellTests.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 08/11/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OrderCell.h"

@interface OrderCellTests : XCTestCase

@end

@implementation OrderCellTests

- (void)testProperlyManipulatesConstraintWithPanGesture {
  OrderCell *orderCell = [[[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:self options:nil] lastObject];
//  [orderCell receivedPanGesture:<#(UIPanGestureRecognizer *)panGesture#>];
//  orderCell.leftMarginConstraint.constant
}

@end
