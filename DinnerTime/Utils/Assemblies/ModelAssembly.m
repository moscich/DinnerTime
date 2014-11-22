//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "ModelAssembly.h"
#import "DinnerManager.h"
#import "ServiceAssembly.h"
#import "LoginManager.h"


@implementation ModelAssembly {

}

- (TyphoonDefinition *)registerDinnerManager{
  return [TyphoonDefinition withClass:[DinnerManager class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithDinnerTimeService:) parameters:^(TyphoonMethod *initializer){
      [initializer injectParameterWith:[self.serviceAssembly registerDinnerService]];
    }];
      [definition injectProperty:@selector(webSocketService) with:[self.serviceAssembly registerWebSocketService]];
      definition.scope = TyphoonScopeLazySingleton;
  }];
}

- (TyphoonDefinition *)registerLoginManager{
    return [TyphoonDefinition withClass:[LoginManager class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithGoogleSignInManager:withDinnerTimeService:) parameters:^(TyphoonMethod *initializer){
            [initializer injectParameterWith:[self.serviceAssembly registerLoginService]];
            [initializer injectParameterWith:[self.serviceAssembly registerDinnerService]];
        }];
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

@end