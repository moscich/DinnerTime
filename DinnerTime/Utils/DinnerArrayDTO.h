//
// Created by Marek Moscichowski on 11/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@protocol DinnerDTO
@end

@interface DinnerArrayDTO : JSONModel
@property(nonatomic, strong) NSArray <DinnerDTO> *dinners;
@end