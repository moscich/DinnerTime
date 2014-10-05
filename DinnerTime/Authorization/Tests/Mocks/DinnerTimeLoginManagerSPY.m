//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerTimeLoginManagerSPY.h"


@implementation DinnerTimeLoginManagerSPY {

}

- (void)signInWithToken:(NSString *)token {
  self.token = token;
}

@end