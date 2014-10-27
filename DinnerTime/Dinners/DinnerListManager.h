//
// Created by Marek Mościchowski on 27/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DinnerManagerDataSource;


@interface DinnerListManager : NSObject <UITableViewDataSource>

@property(nonatomic, weak) id <DinnerManagerDataSource> dataSource;

@end