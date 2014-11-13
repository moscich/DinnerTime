//
//  AppDelegate.h
//  DinnerTime
//
//  Created by Marek Moscichowski on 25/09/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DinnerManager;
@class TyphoonAssembly;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TyphoonAssembly *assembly;


@end

