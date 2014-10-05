//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerTimeLoginManager.h"


@interface DinnerTimeLoginManagerDelegateSpy : NSObject <DinnerTimeLoginManagerDelegate>
@property (nonatomic, assign) BOOL wasCalled;
@end