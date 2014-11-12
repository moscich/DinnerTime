//
// Created by Marek Moscichowski on 27/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "OrderListManager.h"
#import "DinnerManager.h"
#import "DinnerDTO.h"
#import "OrderDTO.h"
#import "DinnerCell.h"
#import "DinnerSummaryCell.h"
#import "OrderCell.h"


@implementation OrderListManager {

}

- (instancetype)initWithDinnerId:(int)dinnerId {
  self = [super init];
  if (self) {
    self.dinnerId = dinnerId;
  }

  return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0)
    return 1;
  DinnerDTO *dinner = [self.dataSource dinnerWithId:self.dinnerId];
  return dinner.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  DinnerDTO *dinner = [self.dataSource dinnerWithId:self.dinnerId];
  if (indexPath.section == 0) {
    DinnerSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DinnerSummaryCellIdentifier"];
    cell.textLabel.text = dinner.title;
    cell.detailsLabel.text = dinner.details;
    cell.ownerLabel.text = dinner.owner;
    return cell;
  } else {
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCellIdentifier"];
    cell.textLabel.text = ((OrderDTO *) dinner.orders[(NSUInteger) indexPath.row]).order;
    cell.delegate = self;
    cell.tag = indexPath.row;
    return cell;
  }
  return nil;
}

- (void)orderWasPaid:(OrderCell *)orderCell {
  [self.delegate orderWasPaid:@(orderCell.tag)];
}

- (void)orderWasUnpaid:(OrderCell *)orderCell {
  [self.delegate orderWasUnpaid:@(orderCell.tag)];
}

- (void)orderWasDeleted:(OrderCell *)orderCell {

}


@end