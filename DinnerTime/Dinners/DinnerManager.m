//
// Created by Marek Moscichowski on 06/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerManager.h"
#import "DinnerTimeServiceSpy.h"
#import "DinnerTimeService.h"
#import "DinnerDTO.h"
#import "DinnerCell.h"

@interface DinnerManager ()

@property(nonatomic, strong) NSArray *dinners;
@property(nonatomic, assign) DinnerServiceResultType resultType;

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
    self.resultType = DinnerServiceResult_Success;
    callback(DinnerServiceResult_Success);
  } failure:^(DinnerServiceResultType type) {
    self.resultType = type;
    callback(type);
  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dinners.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  DinnerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DinnerCellIdentifier"];
  DinnerDTO *dinner = self.dinners[(NSUInteger) indexPath.row];
  cell.textLabel.text = dinner.title;
  cell.ownerLabel.text = dinner.owner;
  return cell;
}

- (DinnerServiceResultType)lastResultType {
  return self.resultType;
}

@end