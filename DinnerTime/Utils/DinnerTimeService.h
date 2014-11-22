//
// Created by Marek Moscichowski on 17/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerServiceResultType.h"

@class DinnerSessionManager;
@class OrderDTO;
@class DinnerDTO;
@class DinnerSessionBuilder;

@protocol DinnerTimeService <NSObject>

@property(nonatomic, strong) DinnerSessionManager *dinnerSessionManager;

- (void)logout:(void (^)(DinnerServiceResultType))callback;

- (void)loginWithToken:(NSString *)token withCallback:(void (^)(NSString *sessionId))callback;

- (id)initWithDinnerSessionBuilder:(DinnerSessionBuilder *)dinnerSessionBuilder;

- (void)getDinners:(void (^)(NSArray *))callback failure:(void (^)(DinnerServiceResultType))failure;

- (void)postDinner:(DinnerDTO *)dto withCallback:(void (^)(DinnerDTO *))callback;

- (void)postOrder:(NSString *)order withDinnerId:(int)dinnerId withCallback:(void (^)(OrderDTO *))callback;

- (void)changeOrderWithId:(NSNumber *)orderId toPaid:(NSNumber *)paid;

@end