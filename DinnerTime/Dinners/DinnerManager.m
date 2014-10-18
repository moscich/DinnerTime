//
// Created by Marek Moscichowski on 06/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerManager.h"
#import "DinnerTimeServiceSpy.h"
#import "DinnerTimeService.h"
#import "DinnerDTO.h"

@interface DinnerManager ()

@property(nonatomic, strong) NSArray *dinners;

@end

@implementation DinnerManager {

}

- (instancetype)initWithDinnerTimeService:(DinnerTimeService *)dinnerTimeService {
  self = [super init];
  if (self) {
    self.dinnerTimeService = dinnerTimeService;
  }

  return self;
}

- (void)getDinners:(void (^)(DinnerServiceResultType type))callback {
  [self.dinnerTimeService getDinners:^(NSArray *array) {
    self.dinners = array;
    callback(DinnerServiceResult_Success);
  } failure:^(DinnerServiceResultType type) {
    callback(type);
  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dinners.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [UITableViewCell new];
  cell.textLabel.text = ((DinnerDTO *)self.dinners[(NSUInteger) indexPath.row]).title;
  return cell;
}

@end