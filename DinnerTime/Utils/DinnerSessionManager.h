//
// Created by Marek Moscichowski on 10/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface DinnerSessionManager : NSObject

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, strong) NSString *sessionId;

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)sessionManager;
- (void)GET:(NSString *)string parameters:(NSDictionary *)parameters success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure;
- (void)POST:(NSString *)string parameters:(NSDictionary *)parameters success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure;

@end