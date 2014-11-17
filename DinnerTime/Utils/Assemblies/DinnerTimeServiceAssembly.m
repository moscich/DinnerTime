//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Typhoon/TyphoonConfigPostProcessor.h>
#import "DinnerTimeServiceAssembly.h"
#import "DinnerTimeServiceImpl.h"
#import "DinnerSessionBuilder.h"
#import "DinnerWebSocketServiceImpl.h"
#import "ModelAssembly.h"


@implementation DinnerTimeServiceAssembly {

}

- (TyphoonDefinition *)registerDinnerService{
  return [TyphoonDefinition withClass:[DinnerTimeServiceImpl class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithDinnerSessionBuilder:) parameters:^(TyphoonMethod *initializer){
      [initializer injectParameterWith:[self registerSessionBuilder]];

    }];
  }];
}

- (TyphoonDefinition *)registerSessionBuilder{
  return [TyphoonDefinition withClass:[DinnerSessionBuilder class] configuration:^(TyphoonDefinition *definition) {
    [definition injectProperty:@selector(urlString) with:TyphoonConfig(@"urlService")];
  }];
}

- (TyphoonDefinition *)registerWebSocketService {
    return [TyphoonDefinition withClass:[DinnerWebSocketServiceImpl class] configuration:^(TyphoonDefinition *definition) {
      [definition injectProperty:@selector(delegate) with:[self.modelAssembly registerDinnerManager]];
    }];
}

@end