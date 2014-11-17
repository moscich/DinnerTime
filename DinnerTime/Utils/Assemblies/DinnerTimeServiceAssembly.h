//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceAssembly.h"

@class ModelAssembly;


@interface DinnerTimeServiceAssembly : ServiceAssembly
@property (nonatomic, strong) ModelAssembly *modelAssembly;
@end