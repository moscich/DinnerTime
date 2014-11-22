//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "FakeServiceAssembly.h"
#import "FakeWebSocketService.h"
#import "FakeDinnerTimeService.h"
#import "FakeGoogleManager.h"


@implementation FakeServiceAssembly {

}

- (TyphoonDefinition *)registerDinnerService {
  return [TyphoonDefinition withClass:[FakeDinnerTimeService class]];
}

- (TyphoonDefinition *)registerWebSocketService {
    return [TyphoonDefinition withClass:[NSObject class]];
}

- (TyphoonDefinition *)registerLoginService {
  return [TyphoonDefinition withClass:[FakeGoogleManager class]];
}

@end