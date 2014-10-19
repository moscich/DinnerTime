//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "DinnerServiceResultType.h"

@class DinnerSessionBuilder;
@class DinnerSessionManager;

@interface DinnerTimeService : NSObject

@property(nonatomic, strong) DinnerSessionManager *dinnerSessionManager;
@property(nonatomic, copy) NSString *session;

- (void)logout;

- (void)loginWithToken:(NSString *)token withCallback:(void (^)(NSString *sessionId))callback;

- (id)initWithDinnerSessionBuilder:(DinnerSessionBuilder *)dinnerSessionBuilder;

- (void)getDinners:(void (^)(NSArray *))callback failure:(void (^)(DinnerServiceResultType))failure;
@end