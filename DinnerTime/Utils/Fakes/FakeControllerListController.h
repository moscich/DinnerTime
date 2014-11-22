//
// Created by Marek Moscichowski on 19/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TyphoonAssembly;


@interface FakeControllerListController : UITableViewController

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) TyphoonAssembly *assembly;

@end