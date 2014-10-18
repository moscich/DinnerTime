//
// Created by Marek Moscichowski on 06/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerServiceResultType.h"

@class DinnerTimeService;
@protocol UITableViewDataSource;

@interface DinnerManager : NSObject <UITableViewDataSource>
@property(nonatomic, strong) DinnerTimeService *dinnerTimeService;

- (instancetype)initWithDinnerTimeService:(DinnerTimeService *)dinnerTimeService;

- (void)getDinners:(void (^)(DinnerServiceResultType type))callback;
@end