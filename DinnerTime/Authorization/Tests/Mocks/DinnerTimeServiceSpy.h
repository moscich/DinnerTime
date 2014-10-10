//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerTimeService.h"


@interface DinnerTimeServiceSpy : DinnerTimeService
@property (nonatomic, strong) NSString *token;
@property(nonatomic, assign) BOOL getDinnersCalled;

@property(nonatomic, strong) NSArray *resultArray;

- (id)initWithArray:(NSArray *)dinnerArray;
@end