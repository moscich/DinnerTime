//
// Created by Marek Moscichowski on 11/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DinnerSessionManager;


@interface DinnerSessionBuilder : NSObject

@property (nonatomic, strong) NSString *urlString;

- (DinnerSessionManager *)constructSessionManager;
@end