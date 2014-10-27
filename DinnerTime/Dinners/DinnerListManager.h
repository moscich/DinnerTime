//
// Created by Marek Mościchowski on 27/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DinnerListViewDataSource.h"

@protocol DinnerManagerDataSource;


@interface DinnerListManager : NSObject <DinnerListViewDataSource>

@property(nonatomic, weak) id <DinnerManagerDataSource> dataSource;

@end