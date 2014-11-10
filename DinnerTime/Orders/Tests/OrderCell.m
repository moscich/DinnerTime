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

@private
  UILabel *_textLabel;
}

@synthesize textLabel = _textLabel;

- (IBAction)receivedPanGesture:(UIPanGestureRecognizer *)panGesture {
  if (panGesture.state == UIGestureRecognizerStateBegan) {
    self.startX = [panGesture locationOfTouch:0 inView:self].x;
    self.startConstant = self.leftMarginConstraint.constant;
  } else if (panGesture.state == UIGestureRecognizerStateChanged) {
    CGFloat gestureX = [panGesture locationOfTouch:0 inView:self].x;
    CGFloat x = self.startConstant + gestureX - self.startX;
    if (x < -self.frame.size.width * 0.7 && !self.paidedButtonExpanded) {
      [self expandPaidButton];
      self.paidedButtonExpanded = YES;
    }
    if (x > -self.frame.size.width * 0.7 && self.paidedButtonExpanded) {
      [self collapsePaidButton];
      self.paidedButtonExpanded = NO;
    }
    if (self.paidedButtonExpanded) {
      self.leftMarginConstraint.constant = -self.frame.size.width + gestureX;
    } else {
      self.leftMarginConstraint.constant = x < 0 ? x : 0;
    }
  } else if (panGesture.state == UIGestureRecognizerStateEnded) {
    if (!self.paidedButtonExpanded) {
      CGFloat gestureX = [panGesture locationInView:self].x;
      CGFloat x = self.startConstant + gestureX - self.startX;
      if (x < -self.frame.size.width * 0.3 || [panGesture velocityInView:self].x < -10) {
        [self animateToButtonsOpened];
      } else if (x > -self.frame.size.width * 0.3 || [panGesture velocityInView:self].x > 0) {
        [self closeButtons];
      }
    } else {
      [self presentNewCellState];
    }
  }
}

- (void)presentNewCellState {
  if (!self.paided)
    [self transitionIntoPaidCell];
  else
    [self transitionIntoNotPaidCell];
  self.paided = !self.paided;
}


- (void)transitionIntoNotPaidCell {
  [UIView animateWithDuration:0.5
                        delay:0
       usingSpringWithDamping:0.5
        initialSpringVelocity:0
                      options:UIViewAnimationOptionTransitionNone
                   animations:^{
    [self.deleteRightSpaceConstraint setActive:YES];
    [self.paidRightMarginSpaceConstraint setActive:NO];
    self.leftMarginConstraint.constant = 0;
    self.textLabel.textColor = [UIColor blackColor];
    self.paidDot.hidden = YES;
    [self layoutIfNeeded];
  } completion:nil];
}

- (void)transitionIntoPaidCell {
  [UIView animateWithDuration:0.5
                        delay:0
       usingSpringWithDamping:0.5
        initialSpringVelocity:0
                      options:UIViewAnimationOptionTransitionNone
                   animations:^{
    [self.deleteRightSpaceConstraint setActive:YES];
    [self.paidRightMarginSpaceConstraint setActive:NO];
    self.leftMarginConstraint.constant = 0;
    self.textLabel.textColor = [UIColor grayColor];
    self.paidDot.hidden = NO;
    [self layoutIfNeeded];
  } completion:nil];
}

- (void)animateToButtonsOpened {
  [UIView animateWithDuration:0.5
                        delay:0
       usingSpringWithDamping:0.5
        initialSpringVelocity:0
                      options:UIViewAnimationOptionTransitionNone
                   animations:^{
    self.leftMarginConstraint.constant = -120;
    [self layoutIfNeeded];
  } completion:nil];
}

- (void)closeButtons {
  [UIView animateWithDuration:0.5
                        delay:0
       usingSpringWithDamping:0.5
        initialSpringVelocity:0
                      options:UIViewAnimationOptionTransitionNone
                   animations:^{
    self.leftMarginConstraint.constant = 0;
    [self layoutIfNeeded];
  } completion:nil];
}

- (void)collapsePaidButton {
  [UIView animateWithDuration:0.5
                        delay:0
       usingSpringWithDamping:0.5
        initialSpringVelocity:0
                      options:UIViewAnimationOptionTransitionNone
                   animations:^{
    [self.deleteRightSpaceConstraint setActive:YES];
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
    [self.deleteRightSpaceConstraint setActive:NO];
    [self.paidRightMarginSpaceConstraint setActive:YES];
    [self layoutIfNeeded];
  } completion:nil];
}

@end