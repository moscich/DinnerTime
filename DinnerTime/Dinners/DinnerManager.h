//
// Created by Marek Moscichowski on 06/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerServiceResultType.h"

@class DinnerTimeService;


@interface DinnerManager : NSObject
@property(nonatomic, strong) DinnerTimeService *dinnerTimeService;

- (void)getDinners:(void (^)(DinnerServiceResultType type))pFunction;
@end