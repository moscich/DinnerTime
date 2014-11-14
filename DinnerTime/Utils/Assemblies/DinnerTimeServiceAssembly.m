//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerTimeServiceAssembly.h"
#import "DinnerTimeService.h"
#import "DinnerSessionBuilder.h"
#import "DinnerWebSocketServiceImpl.h"


@implementation DinnerTimeServiceAssembly {

}

- (TyphoonDefinition *)registerDinnerService{
  return [TyphoonDefinition withClass:[DinnerTimeService class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithDinnerSessionBuilder:) parameters:^(TyphoonMethod *initializer){
      [initializer injectParameterWith:[self registerSessionBuilder]];

    }];
  }];
}

- (TyphoonDefinition *)registerSessionBuilder{
  return [TyphoonDefinition withClass:[DinnerSessionBuilder class]];
}

- (TyphoonDefinition *)registerWebSocketService {
    return [TyphoonDefinition withClass:[DinnerWebSocketServiceImpl class]];
}

@end