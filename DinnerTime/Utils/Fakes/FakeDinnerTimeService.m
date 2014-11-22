//
// Created by Marek Moscichowski on 19/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "FakeDinnerTimeService.h"
#import "DinnerSessionManager.h"
#import "DinnerServiceResultType.h"
#import "DinnerSessionBuilder.h"
#import "DinnerDTO.h"
#import "OrderDTO.h"


@implementation FakeDinnerTimeService {

}
@synthesize dinnerSessionManager;

- (void)logout:(void (^)(DinnerServiceResultType))callback {
  callback(DinnerServiceResult_Success);
}

- (void)loginWithToken:(NSString *)token withCallback:(void (^)(NSString *sessionId))callback {
  callback(@"fakeSessionID");
}

- (id)initWithDinnerSessionBuilder:(DinnerSessionBuilder *)dinnerSessionBuilder {
  self = [super init];
  if (self) {
    self.dinnerSessionManager = [dinnerSessionBuilder constructSessionManager];
  }

  return self;
}


- (void)getDinners:(void (^)(NSArray *))callback failure:(void (^)(DinnerServiceResultType))failure {
  callback([self mockResultOutputArray]);
}

- (void)postDinner:(DinnerDTO *)dto withCallback:(void (^)(DinnerDTO *))callback {
  callback(dto);
}

- (void)postOrder:(NSString *)order withDinnerId:(int)dinnerId withCallback:(void (^)(OrderDTO *))callback {
  OrderDTO *order2 = [OrderDTO new];
  order2.orderId = 3;
  order2.order = order;
  order2.owner = @"Test owner new";
  order2.owned = YES;
  callback(order2);
}

- (void)changeOrderWithId:(NSNumber *)orderId toPaid:(NSNumber *)paid {

}

- (NSArray *)mockResultOutputArray {
  DinnerDTO *dinner1 = [DinnerDTO new];
  dinner1.dinnerId = 1;
  dinner1.owned = YES;
  dinner1.owner = @"MockOwner";
  dinner1.title = @"MockTitle";
  OrderDTO *order1 = [OrderDTO new];
  order1.orderId = 1;
  order1.order = @"Order name";
  order1.owner = @"Test owner";
  order1.owned = YES;
  OrderDTO *order2 = [OrderDTO new];
  order2.orderId = 2;
  order2.order = @"Test order";
  order2.owner = @"Test owner 2";
  order2.owned = NO;
  dinner1.orders = (NSArray <OrderDTO> *) @[order1, order2];
  DinnerDTO *dinner2 = [DinnerDTO new];
  dinner2.dinnerId = 2;
  dinner2.owned = NO;
  dinner2.owner = @"MockOwner2";
  dinner2.title = @"MockTitle2";
  dinner2.orders = (NSArray <OrderDTO> *) @[];
  return @[dinner1, dinner2];
}

@end