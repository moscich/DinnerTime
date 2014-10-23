//
// Created by Marek Moscichowski on 06/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerServiceResultType.h"
#import "DinnerListViewDataSource.h"

@protocol UITableViewDataSource;
@class DinnerTimeService;
@class DinnerDTO;
@class DinnerWebSocketManager;

@interface DinnerManager : NSObject <DinnerListViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) DinnerTimeService *dinnerTimeService;
@property(nonatomic, strong) DinnerWebSocketManager *webSocketManager;

- (instancetype)initWithDinnerTimeService:(DinnerTimeService *)dinnerTimeService;

- (void)getDinners:(void (^)(DinnerServiceResultType type))callback;
- (void)postDinner:(DinnerDTO *)dinner withCallback:(void (^)(DinnerServiceResultType type))callback;
@end