//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface DinnerTimeService : NSObject
@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;

- (void)loginWithToken:(NSString *)token withCallback:(void (^)(NSString *sessionId))callback;

- (void)getDinners:(void (^)(NSArray *))callback;
@end