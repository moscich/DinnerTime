//
// Created by Marek Moscichowski on 23/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerWebSocketManager.h"
#import "DinnerArrayDTO.h"
#import "DinnerUpdateDTO.h"


@implementation DinnerWebSocketManager {

}

- (instancetype)init {
  self = [super init];
  if (self) {
    NSString *urlString = @"ws://192.168.1.133:8001";
    self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    self.webSocket.delegate = self;
    [self.webSocket open];
  }

  return self;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    DinnerUpdateDTO *dinnerUpdate = [[DinnerUpdateDTO alloc] initWithString:message error:nil];
    [self.delegate webSocketReceivedDinnerUpdate:@(dinnerUpdate.dinnerId)];
}


@end