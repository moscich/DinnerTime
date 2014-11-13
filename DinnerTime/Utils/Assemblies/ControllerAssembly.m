//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "ControllerAssembly.h"
#import "LoginViewController.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "ModelAssembly.h"
#import "DinnerListViewController.h"


@implementation ControllerAssembly {

}

- (TyphoonDefinition *)registerLoginViewController{
  return [TyphoonDefinition withClass:[LoginViewController class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithDinnerManager:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[self.modelAssembly registerDinnerManager]];
    }];
  }];
}

- (TyphoonDefinition *)registerDinnerListViewController{
  return [TyphoonDefinition withClass:[DinnerListViewController class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithDinnerManager:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[self.modelAssembly registerDinnerManager]];
    }];
  }];
}

@end