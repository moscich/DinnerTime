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


@implementation OrderListManager {

}

- (instancetype)initWithDinnerId:(int)dinnerId {
  self = [super init];
  if (self) {
    self.dinnerId = dinnerId;
  }

  return self;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  if(indexPath.section == 1)
//    return 44;
//
//}

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
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = ((OrderDTO *) dinner.orders[(NSUInteger) indexPath.row]).order;
    return cell;
  }
  return nil;
}


@end