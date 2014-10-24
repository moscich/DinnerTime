//
// Created by Marek Moscichowski on 06/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerManager.h"
#import "DinnerTimeServiceSpy.h"
#import "DinnerTimeService.h"
#import "DinnerDTO.h"
#import "DinnerCell.h"
#import "DinnerWebSocketManager.h"

@implementation DinnerManager {

}

@synthesize needUpdate;

- (instancetype)initWithDinnerTimeService:(DinnerTimeService *)dinnerTimeService {
  self = [super init];
  if (self) {
    self.dinnerTimeService = dinnerTimeService;
    self.needUpdate = YES;
    self.webSocketManager = [DinnerWebSocketManager new];
    self.webSocketManager.delegate = self;
  }

  return self;
}

- (void)getDinners:(void (^)(DinnerServiceResultType type))callback {
  [self.dinnerTimeService getDinners:^(NSArray *array) {
    self.dinners = [self sortOwnedDinnersFirst:array];
    callback(DinnerServiceResult_Success);
  } failure:^(DinnerServiceResultType type) {
    callback(type);
  }];
}

- (void)postDinner:(DinnerDTO *)dinner withCallback:(void (^)(DinnerServiceResultType type))callback {
  [self.dinnerTimeService postDinner:dinner withCallback:^(DinnerDTO *dinnerDTO){
    if(self.dinners){
      [self.dinners insertObject:dinner atIndex:0];
      self.dinners = self.dinners; // stupid mocking failing :(
    }
    else
      self.dinners = [@[dinnerDTO] mutableCopy];
    callback(DinnerServiceResult_Success);
  }];
}

- (NSMutableArray *)sortOwnedDinnersFirst:(NSArray *)inputArray{
  NSMutableArray *resultArray = [@[] mutableCopy];
  for(int i = 0; i < inputArray.count; i++){
    if(((DinnerDTO *)inputArray[(NSUInteger) i]).owned){
      [resultArray addObject:inputArray[(NSUInteger) i]];
    }
  }
  for(int i = 0; i < inputArray.count; i++){
    if(!((DinnerDTO *)inputArray[(NSUInteger) i]).owned){
      [resultArray addObject:inputArray[(NSUInteger) i]];
    }
  }
  return resultArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dinners.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  DinnerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DinnerCellIdentifier"];
  DinnerDTO *dinner = self.dinners[(NSUInteger) indexPath.row];
  cell.textLabel.text = dinner.title;
  cell.ownerLabel.text = dinner.owner;
  cell.ownerBackground.hidden = !dinner.owned;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (void)webSocketReceivedDinnerUpdate:(NSNumber *)dinnerID {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"DinnerUpdate" object:nil]];
}

@end