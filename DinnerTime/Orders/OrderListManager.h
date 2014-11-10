//
// Created by Marek Moscichowski on 27/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OrderCell.h"

@protocol DinnerManagerDataSource;

@interface OrderListManager : NSObject <UITableViewDataSource, UITableViewDelegate, OrderCellDelegate>
@property(nonatomic, assign) int dinnerId;

@property(nonatomic, weak) id <DinnerManagerDataSource> dataSource;

- (instancetype)initWithDinnerId:(int)dinnerId;

@end