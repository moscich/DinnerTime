//
// Created by Marek Moscichowski on 11/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerSessionBuilder.h"

@class DinnerSessionManager;


@interface DinnerSessionBuilderStub : DinnerSessionBuilder
@property(nonatomic, strong) DinnerSessionManager *dinnerSessionManager;

- (id)initWithDinnerSessionManager:(DinnerSessionManager *)manager;
@end