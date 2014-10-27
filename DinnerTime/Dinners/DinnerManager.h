//
// Created by Marek Moscichowski on 06/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerServiceResultType.h"
#import "DinnerListViewDataSource.h"
#import "DinnerWebSocketManager.h"

@protocol UITableViewDataSource;
@class DinnerTimeService;
@class DinnerDTO;
@class DinnerWebSocketManager;

@protocol DinnerManagerDelegate
- (void)dinnerManagerDidSelectDinnerWithId:(NSNumber *)id;
@end

@interface DinnerManager : NSObject <DinnerListViewDataSource, UITableViewDelegate, DinnerWebSocketManagerDelegate>
@property(nonatomic, strong) DinnerTimeService *dinnerTimeService;
@property(nonatomic, strong) DinnerWebSocketManager *webSocketManager;
@property(nonatomic, strong) NSMutableArray *dinners;

@property(nonatomic, strong) id <DinnerManagerDelegate> delegate;

- (instancetype)initWithDinnerTimeService:(DinnerTimeService *)dinnerTimeService;

- (void)getDinners:(void (^)(DinnerServiceResultType type))callback;
- (void)postDinner:(DinnerDTO *)dinner withCallback:(void (^)(DinnerServiceResultType type))callback;
@end