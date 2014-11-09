//
// Created by Marek Moscichowski on 08/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCell.h"


@interface OrderCell ()

@property(nonatomic, assign) CGFloat startX;
@property(nonatomic, assign) CGFloat startConstant;

@end

@implementation OrderCell {

}

- (IBAction)receivedPanGesture:(UIPanGestureRecognizer *)panGesture {
  if (panGesture.state == UIGestureRecognizerStateBegan) {
    self.startX = [panGesture locationOfTouch:0 inView:self].x;
    self.startConstant = self.leftMarginConstraint.constant;
  } else if (panGesture.state == UIGestureRecognizerStateChanged) {
    CGFloat gestureX = [panGesture locationOfTouch:0 inView:self].x;
    CGFloat x = self.startConstant + gestureX - self.startX;
    if (x < -self.frame.size.width * 0.7 && !self.paidedExpanded) {
      [self expandPaidButton];
      self.paidedExpanded = YES;
    }
    if (x > -self.frame.size.width * 0.7 && self.paidedExpanded) {
      [self collapsePaidButton];
      self.paidedExpanded = NO;
    }
    if (self.paidedExpanded) {
      self.leftMarginConstraint.constant = -self.frame.size.width + gestureX;
    } else {
      self.leftMarginConstraint.constant = x < 0 ? x : 0;
    }
  }
}

- (void)collapsePaidButton {
  [UIView animateWithDuration:0.5
                        delay:0
       usingSpringWithDamping:0.5
        initialSpringVelocity:0
                      options:UIViewAnimationOptionTransitionNone
                   animations:^{
    [self.paidDeleteSpaceConstraint setActive:YES];
    [self.paidRightMarginSpaceConstraint setActive:NO];
    [self layoutIfNeeded];
  } completion:nil];
}


- (void)expandPaidButton {
  [UIView animateWithDuration:0.5
                        delay:0
       usingSpringWithDamping:0.5
        initialSpringVelocity:0
                      options:UIViewAnimationOptionTransitionNone
                   animations:^{
    [self.paidDeleteSpaceConstraint setActive:NO];
    [self.paidRightMarginSpaceConstraint setActive:YES];
    [self layoutIfNeeded];
  } completion:nil];
}


@end