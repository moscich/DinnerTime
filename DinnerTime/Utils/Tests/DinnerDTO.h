//
// Created by Marek Moscichowski on 10/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DinnerDTO : NSObject
@property(nonatomic) int id;
@property(nonatomic) BOOL owned;
@property(nonatomic, copy) NSString *owner;
@property(nonatomic, copy) NSString *title;
@end