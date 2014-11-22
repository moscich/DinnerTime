//
// Created by Marek Moscichowski on 19/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "FakeApplicationAssembly.h"
#import "AppDelegate.h"
#import "FakeRootViewController.h"
#import "FakeControllerListController.h"

@implementation FakeApplicationAssembly {

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

- (FakeRootViewController *)rootViewController {
  return [TyphoonDefinition withClass:[FakeRootViewController class] configuration:^(TyphoonDefinition *definition) {
    [definition injectProperty:@selector(navigationController) with:[self childNavigationController]];
    [definition injectMethod:@selector(addChildViewController:) parameters:^(TyphoonMethod *method) {
      [method injectParameterWith:[self childNavigationController]];
    }];
  }];
}

- (UINavigationController *)childNavigationController{
  return [TyphoonDefinition withClass:[UINavigationController class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithRootViewController:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[self fakeControllerListController]];
    }];
  }];
}

- (FakeControllerListController *)fakeControllerListController{
  return [TyphoonDefinition withClass:[FakeControllerListController class] configuration:^(TyphoonDefinition *definition) {
    [definition injectProperty:@selector(assembly) with:self];
  }];
}

@end