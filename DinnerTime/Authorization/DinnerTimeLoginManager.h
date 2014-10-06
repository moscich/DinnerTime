//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DinnerTimeService;
@class DinnerTimeLoginManagerDelegateSpy;

@protocol DinnerTimeLoginManagerDelegate
- (void)dinnerTimeLoginManagerLoginSuccessfullyWithSession:(NSString *)sessionId;
@end

@interface DinnerTimeLoginManager : NSObject
@property (nonatomic, strong) DinnerTimeService *dinnerTimeService;
@property(nonatomic, strong) id <DinnerTimeLoginManagerDelegate> delegate;

- (void)signInWithToken:(NSString *)token;
@end