//
// Created by Marek Moscichowski on 06/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DinnerManager.h"
#import "DinnerTimeServiceSpy.h"
#import "DinnerTimeService.h"
#import "DinnerDTO.h"
#import "DinnerCell.h"
#import "DinnerWebSocketManager.h"
#import "DinnerListManager.h"
#import "OrderListManager.h"
#import "OrderDTO.h"

@implementation DinnerManager {

}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.webSocketManager = [DinnerWebSocketManager new];
    self.webSocketManager.delegate = self;
    self.dinnerListManager = [DinnerListManager new];
    self.dinnerListManager.dataSource = self;
  }

  return self;
}

- (instancetype)initWithDinnerTimeService:(DinnerTimeService *)dinnerTimeService {
  self = [self init];
  if (self) {
    self.dinnerTimeService = dinnerTimeService;
  }

  return self;
}

- (void)getDinners:(void (^)(DinnerServiceResultType type))callback {
  [self.dinnerTimeService getDinners:^(NSArray *array) {
    self.dinners = [self sortOwnedDinnersFirst:array];
    callback(DinnerServiceResult_Success);
  }                          failure:^(DinnerServiceResultType type) {
    callback(type);
  }];
}

- (void)postDinner:(DinnerDTO *)dinner withCallback:(void (^)(DinnerServiceResultType type))callback {
  [self.dinnerTimeService postDinner:dinner withCallback:^(DinnerDTO *dinnerDTO){
    if (self.dinners) {
      [self.dinners insertObject:dinner atIndex:0];
      self.dinners = self.dinners; // stupid mocking failing :(
    }
    else
      self.dinners = [@[dinnerDTO] mutableCopy];
    callback(DinnerServiceResult_Success);
  }];
}

- (void)postOrder:(NSString *)string withCallback:(void (^)(DinnerServiceResultType type))callback {
    int dinnerId = self.orderListManager.dinnerId;
    [self.dinnerTimeService postOrder:string withDinnerId:dinnerId withCallback:^(OrderDTO *order) {
        for (DinnerDTO *dinner in self.dinners) {
            if (dinner.dinnerId == dinnerId) {
                if (!dinner.orders)
                    dinner.orders = (NSArray <OrderDTO, Optional> *) @[];
                dinner.orders = (NSArray <OrderDTO, Optional> *) [dinner.orders arrayByAddingObject:order];
                callback(DinnerServiceResult_Success);
            }
        }
    }];
}

- (NSMutableArray *)sortOwnedDinnersFirst:(NSArray *)inputArray {
  NSMutableArray *resultArray = [@[] mutableCopy];
  for (int i = 0; i < inputArray.count; i++) {
    if (((DinnerDTO *) inputArray[(NSUInteger) i]).owned) {
      [resultArray addObject:inputArray[(NSUInteger) i]];
    }
  }
  for (int i = 0; i < inputArray.count; i++) {
    if (!((DinnerDTO *) inputArray[(NSUInteger) i]).owned) {
      [resultArray addObject:inputArray[(NSUInteger) i]];
    }
  }
  return resultArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  DinnerDTO *dinner = self.dinners[(NSUInteger) indexPath.row];
  self.orderListManager = [[OrderListManager alloc] initWithDinnerId:dinner.dinnerId];
  self.orderListManager.dataSource = self;
  [self.delegate dinnerManagerDidSelectDinner];
}

- (void)webSocketReceivedDinnerUpdate:(NSNumber *)dinnerID {
  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"DinnerUpdate" object:nil]];
}

- (NSArray *)dinnerManagerDinners {
    return self.dinners;
}

@end