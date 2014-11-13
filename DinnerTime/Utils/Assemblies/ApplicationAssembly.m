//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "ApplicationAssembly.h"
#import "AppDelegate.h"
#import "ModelAssembly.h"
#import "ControllerAssembly.h"


@implementation ApplicationAssembly {

}

- (AppDelegate *)appDelegate {
  return [TyphoonDefinition withClass:[AppDelegate class] configuration:^(TyphoonDefinition *definition)
          {
            [definition injectProperty:@selector(window) with:[self mainWindow]];
            [definition injectProperty:@selector(assembly) with:self];
          }];
}

- (UIWindow *)mainWindow {
  return [TyphoonDefinition withClass:[UIWindow class] configuration:^(TyphoonDefinition *definition)
          {
            [definition useInitializer:@selector(initWithFrame:) parameters:^(TyphoonMethod *initializer)
                    {
                      [initializer injectParameterWith:[NSValue valueWithCGRect:[[UIScreen mainScreen] bounds]]];
                    }];
            [definition injectProperty:@selector(rootViewController) with:[self rootViewController]];
          }];
}

- (UINavigationController *)rootViewController {
  return [TyphoonDefinition withClass:[UINavigationController class] configuration:^(TyphoonDefinition *definition) {
    [definition injectProperty:@selector(viewControllers) with:@[[self.controllerAssembly registerLoginViewController], [self.controllerAssembly registerDinnerListViewController]]];
  }];
}

@end