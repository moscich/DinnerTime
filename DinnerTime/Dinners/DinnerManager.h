//
// Created by Marek Moscichowski on 06/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerServiceResultType.h"
#import "DinnerWebSocketServiceImpl.h"
#import "OrderListManager.h"

@protocol UITableViewDataSource;
@protocol UITableViewDelegate;
@class DinnerTimeServiceImpl;
@class DinnerDTO;
@class DinnerWebSocketServiceImpl;
@class DinnerListManager;
@class OrderListManager;

@protocol DinnerManagerDelegate
- (void)dinnerManagerDidSelectDinner;
@end

@protocol DinnerManagerDataSource
- (NSArray *)dinnerManagerDinners;
- (DinnerDTO *)dinnerWithId:(int)dinnerId;
@end

@interface DinnerManager : NSObject <UITableViewDelegate, DinnerWebSocketServiceDelegate, DinnerManagerDataSource, OrderListManagerDelegate>
@property(nonatomic, strong) DinnerTimeServiceImpl *dinnerTimeService;
@property(nonatomic, strong) id <DinnerWebSocketService> webSocketService;
@property(nonatomic, strong) NSMutableArray *dinners;
@property(nonatomic, strong) DinnerListManager *dinnerListManager;
@property(nonatomic, strong) OrderListManager *orderListManager;
@property(nonatomic, weak) id <DinnerManagerDelegate> delegate;

- (instancetype)initWithDinnerTimeService:(DinnerTimeServiceImpl *)dinnerTimeService;

- (void)getDinners:(void (^)(DinnerServiceResultType type))callback;
- (void)postDinner:(DinnerDTO *)dinner withCallback:(void (^)(DinnerServiceResultType type))callback;
- (void)postOrder:(NSString *)string withCallback:(void (^)(DinnerServiceResultType type))callback;

@end