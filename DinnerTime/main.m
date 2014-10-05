//
//  main.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 25/09/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TestsAppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
      if(NSClassFromString(@"XCTest") == nil)
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
      else
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([TestsAppDelegate class]));
    }
}
