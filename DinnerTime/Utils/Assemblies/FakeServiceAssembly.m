//
// Created by Marek Moscichowski on 12/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "FakeServiceAssembly.h"
#import "FakeWebSocketService.h"


@implementation FakeServiceAssembly {

}

- (TyphoonDefinition *)registerDinnerService {
  return [TyphoonDefinition withClass:[FakeWebSocketService class]];
}

- (TyphoonDefinition *)registerWebSocketService {
    return [TyphoonDefinition withClass:[NSObject class]];
}

@end