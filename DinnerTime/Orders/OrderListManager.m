//
// Created by Marek Moscichowski on 27/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "OrderListManager.h"
#import "DinnerManager.h"
#import "DinnerDTO.h"
#import "OrderDTO.h"


@implementation OrderListManager {

}
- (instancetype)initWithDinnerId:(int)dinnerId {
  self = [super init];
  if (self) {
    self.dinnerId = dinnerId;
  }

  return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *dinners = [self.dataSource dinnerManagerDinners];
  for(DinnerDTO *dinner in dinners){
    if(dinner.dinnerId == self.dinnerId)
      return dinner.orders.count;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *dinners = [self.dataSource dinnerManagerDinners];
  for(DinnerDTO *dinner in dinners){
    if(dinner.dinnerId == self.dinnerId){
      UITableViewCell *cell = [UITableViewCell new];
      cell.textLabel.text = ((OrderDTO *)dinner.orders[(NSUInteger) indexPath.row]).order;
      return cell;
    }
  }

      return nil;
}


@end