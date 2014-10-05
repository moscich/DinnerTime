//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DinnerTimeService : NSObject
@property(nonatomic, strong) id sessionManager;

- (void)loginWithToken:(NSString *)token withCallback:(void (^)(NSString *sessionId))callback;
@end