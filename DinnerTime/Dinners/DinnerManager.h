//
// Created by Marek Moscichowski on 06/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerServiceResultType.h"
#import "DinnerListViewDataSource.h"

@class DinnerTimeService;
@protocol UITableViewDataSource;
@class DinnerDTO;

@interface DinnerManager : NSObject <DinnerListViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) DinnerTimeService *dinnerTimeService;

- (instancetype)initWithDinnerTimeService:(DinnerTimeService *)dinnerTimeService;

- (void)getDinners:(void (^)(DinnerServiceResultType type))callback;
- (void)postDinner:(DinnerDTO *)dinner withCallback:(void (^)(DinnerServiceResultType type))callback;
@end