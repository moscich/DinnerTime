//
// Created by Marek Mościchowski on 27/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>


@interface OrderDTO : JSONModel
@property(nonatomic) int orderId;
@property(nonatomic, copy) NSString *order;
@property(nonatomic, copy) NSString *owner;
@property(nonatomic) BOOL owned;
@end