//
// Created by Marek Moscichowski on 11/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerSessionBuilderStub.h"
#import "DinnerSessionManager.h"


@implementation DinnerSessionBuilderStub {

}
- (id)initWithDinnerSessionManager:(DinnerSessionManager *)manager {
  self = [super init];
  if(self){
    self.dinnerSessionManager = manager;
  }
  return self;
}

- (DinnerSessionManager *)constructSessionManager {
  return self.dinnerSessionManager;
}

@end