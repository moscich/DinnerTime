//
// Created by Marek Moscichowski on 09/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerManager.h"


@interface DinnerManagerSpy : DinnerManager

@property(nonatomic) BOOL getDinnersAsked;
@property(nonatomic) DinnerServiceResultType resultType;

- (id)initWithResultType:(DinnerServiceResultType)type;
@end