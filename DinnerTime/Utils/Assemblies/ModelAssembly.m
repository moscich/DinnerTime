//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "ModelAssembly.h"
#import "DinnerManager.h"
#import "ServiceAssembly.h"


@implementation ModelAssembly {

}

- (TyphoonDefinition *)registerDinnerManager{
  return [TyphoonDefinition withClass:[DinnerManager class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithDinnerTimeService:) parameters:^(TyphoonMethod *initializer){
      [initializer injectParameterWith:[self.serviceAssembly registerDinnerService]];
    }];
    definition.scope = TyphoonScopeLazySingleton;
  }];
}

@end