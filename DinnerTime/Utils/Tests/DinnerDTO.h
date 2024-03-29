//
// Created by Marek Moscichowski on 10/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@protocol OrderDTO
@end

@interface DinnerDTO : JSONModel
@property(nonatomic) int dinnerId;
@property(nonatomic) BOOL owned;
@property(nonatomic, copy) NSString *owner;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSArray <OrderDTO,Optional> *orders;
@property(nonatomic, copy) NSString *details;
@end