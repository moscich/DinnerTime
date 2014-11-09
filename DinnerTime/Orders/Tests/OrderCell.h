//
// Created by Marek Moscichowski on 08/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIPanGestureRecognizer;


@interface OrderCell : UITableViewCell

- (IBAction)receivedPanGesture:(UIPanGestureRecognizer *)panGesture;
- (IBAction)presentNewCellState;

@property(nonatomic, strong) IBOutlet UILabel *textLabel;
@property(nonatomic, strong) IBOutlet UIView *paidDot;

@property (nonatomic, assign) BOOL paidedButtonExpanded;
@property (nonatomic, assign) BOOL paided;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leftMarginConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *paidDeleteSpaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *paidRightMarginSpaceConstraint;

@end