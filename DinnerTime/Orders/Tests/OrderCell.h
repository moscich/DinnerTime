//
// Created by Marek Moscichowski on 08/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIPanGestureRecognizer;
@class OrderCell;

@protocol OrderCellDelegate
- (void)orderWasPaid:(OrderCell *)orderCell;
- (void)orderWasUnpaid:(OrderCell *)orderCell;
- (void)orderWasDeleted:(OrderCell *)orderCell;
@end

@interface OrderCell : UITableViewCell

- (IBAction)receivedPanGesture:(UIPanGestureRecognizer *)panGesture;
- (IBAction)changePaidState;
- (IBAction)closeButtons;

@property(nonatomic, weak) id <OrderCellDelegate> delegate;

@property(nonatomic, strong) IBOutlet UILabel *textLabel;
@property(nonatomic, strong) IBOutlet UIView *paidDot;

@property (nonatomic, assign) BOOL paidedButtonExpanded;
@property (nonatomic, assign) BOOL paided;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leftMarginConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *deleteRightSpaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *paidRightMarginSpaceConstraint;

@end