//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "DinnerServiceResultType.h"


@interface HttpSessionManagerSpy : AFHTTPSessionManager
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) NSString *calledAddress;
@property (nonatomic, strong) NSData *resultArray;

@property(nonatomic) DinnerServiceResultType returnType;

- (id)initWithReturnType:(DinnerServiceResultType)type;

- (instancetype)initWithResultData:(NSData *)resultData;

@end