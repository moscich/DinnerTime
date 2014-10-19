//
// Created by Marek Moscichowski on 11/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DinnerSessionManager.h"
#import "DinnerServiceResultType.h"


@interface DinnerSessionManagerSpy : DinnerSessionManager
@property(nonatomic, copy) NSString *sessionJSON;
@property(nonatomic, strong) NSDictionary *parameters;
@property(nonatomic, strong) NSString *postCalledAddress;

@property(nonatomic, copy) NSString *dinnerJSON;

@property(nonatomic, assign) DinnerServiceResultType returnType;

@property(nonatomic, copy) NSString *getCalledAddress;

- (id)initWithSessionJSON:(NSString *)sessionJSON;

- (id)initWithDinnerJSON:(NSString *)jsonString;

- (id)initWithResultType:(DinnerServiceResultType)type;
@end