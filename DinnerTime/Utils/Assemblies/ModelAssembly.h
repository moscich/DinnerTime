//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"

@class ServiceAssembly;


@interface ModelAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) ServiceAssembly *serviceAssembly;

- (TyphoonDefinition *)registerDinnerManager;

- (TyphoonDefinition *)registerLoginManager;
@end