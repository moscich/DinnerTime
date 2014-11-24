//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon/TyphoonAssembly.h>

@class ModelAssembly;


@interface ControllerAssembly : TyphoonAssembly

@property (nonatomic,strong) ModelAssembly *modelAssembly;

- (TyphoonDefinition *)registerLoginViewController;

- (TyphoonDefinition *)registerDinnerListViewController;

@end