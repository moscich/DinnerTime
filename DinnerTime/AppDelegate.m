//
//  AppDelegate.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 25/09/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <GooglePlus/GooglePlus.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DinnerListViewController.h"
#import "DinnerSessionBuilder.h"
#import "DinnerTimeService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];

  UINavigationController *navigationController = [UINavigationController new];
  DinnerTimeService *dinnerTimeService = [[DinnerTimeService alloc] initWithDinnerSessionBuilder:[DinnerSessionBuilder new]];
  DinnerManager *dinnerManager = [[DinnerManager alloc] initWithDinnerTimeService:dinnerTimeService];

  LoginViewController *loginViewController = [[LoginViewController alloc] initWithDinnerManager:dinnerManager];
  DinnerListViewController *dinnerListViewController = [[DinnerListViewController alloc] initWithDinnerManager:dinnerManager];
  dinnerListViewController.loginManager = loginViewController.loginManager;
  navigationController.viewControllers = @[loginViewController, dinnerListViewController];
  self.window.rootViewController = navigationController;

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
