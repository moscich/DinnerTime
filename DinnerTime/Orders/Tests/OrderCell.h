//
// Created by Marek Moscichowski on 08/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIPanGestureRecognizer;


@interface OrderCell : UITableViewCell

- (IBAction)receivedPanGesture:(UIPanGestureRecognizer *)panGesture;

@property (nonatomic, assign) BOOL paidedExpanded;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leftMarginConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *paidDeleteSpaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *paidRightMarginSpaceConstraint;

@end