//
// Created by Marek Mościchowski on 27/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "OrderDTO.h"


@implementation OrderDTO {

}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[OrderDTO class]]) {
        OrderDTO *order = object;
        return [self.order isEqualToString:order.order] && self.orderId == order.orderId && [self.owner isEqualToString:order.owner] && self.owned == order.owned;
    }
    return NO;
}

@end