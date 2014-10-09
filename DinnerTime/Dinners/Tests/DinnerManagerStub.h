//
// Created by Marek Moscichowski on 09/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerManager.h"
#import "DinnerServiceResultType.h"


@interface DinnerManagerStub : DinnerManager

@property(nonatomic, assign) DinnerServiceResultType type;

- (instancetype)initWithReturnType:(DinnerServiceResultType)type;
@end