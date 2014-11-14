//
//  AppDelegate.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 25/09/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <GooglePlus/GooglePlus.h>
#import <Typhoon/TyphoonAssembly.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DinnerListViewController.h"
#import "DinnerSessionBuilder.h"
#import "DinnerTimeService.h"
#import "DinnerManager.h"
#import "TyphoonBlockComponentFactory.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];

  [[self.assembly asFactory] makeDefault];

  return YES;
}

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
  return [GPPURLHandler handleURL:url
                sourceApplication:sourceApplication
                       annotation:annotation];
}

@end
