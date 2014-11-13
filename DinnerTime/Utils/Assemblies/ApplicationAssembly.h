//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon/TyphoonAssembly.h>

@class ModelAssembly;
@class ControllerAssembly;


@interface ApplicationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) ControllerAssembly *controllerAssembly;

@end