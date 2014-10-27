//
// Created by Marek Moscichowski on 10/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerDTO.h"


@implementation DinnerDTO {

}

- (BOOL)isEqual:(id)object {
  if ([object isKindOfClass:[DinnerDTO class]]) {
    DinnerDTO *dinner = object;
    return dinner.dinnerId == self.dinnerId &&
            dinner.owned == self.owned &&
            [dinner.owner isEqualToString:self.owner] &&
            [dinner.title isEqualToString:self.title] &&
            ([dinner.orders isEqualToArray:self.orders] || (dinner.orders == nil && self.orders == nil));

  }
  return NO;
}

@end