//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"


@interface ServiceAssembly : TyphoonAssembly


- (TyphoonDefinition *)registerDinnerService;

- (TyphoonDefinition *)registerLoginService;

- (TyphoonDefinition *)registerWebSocketService;
@end