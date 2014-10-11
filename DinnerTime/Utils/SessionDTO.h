//
// Created by Marek Moscichowski on 11/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@interface SessionDTO : JSONModel
@property(nonatomic, strong) NSString *sessionId;
@end