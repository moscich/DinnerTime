//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "ControllerAssembly.h"
#import "LoginViewController.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "ModelAssembly.h"
#import "DinnerListViewController.h"
#import "OrderListViewController.h"


@implementation ControllerAssembly {

}

- (TyphoonDefinition *)registerLoginViewController {
  return [TyphoonDefinition withClass:[LoginViewController class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithDinnerManager:loginManager:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[self.modelAssembly registerDinnerManager]];
      [initializer injectParameterWith:[self.modelAssembly registerLoginManager]];
    }];
    [definition injectProperty:@selector(assembly) with:self];
  }];
}

- (TyphoonDefinition *)registerDinnerListViewController {
  return [TyphoonDefinition withClass:[DinnerListViewController class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithDinnerManager:loginManager:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[self.modelAssembly registerDinnerManager]];
      [initializer injectParameterWith:[self.modelAssembly registerLoginManager]];
    }];
    [definition injectProperty:@selector(assembly) with:self];
  }];
}

- (TyphoonDefinition *)addDinnerViewController {
  return [TyphoonDefinition withClass:[AddDinnerViewController class]];
}

- (TyphoonDefinition *)addOrderViewController {
  return [TyphoonDefinition withClass:[AddOrderViewController class]];
}

- (TyphoonDefinition *)registerOrderListViewController {
  return [TyphoonDefinition withClass:[OrderListViewController class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithDinnerManager:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:[self.modelAssembly registerDinnerManager]];
    }];
    [definition injectProperty:@selector(assembly) with:self];
  }];
}

@end