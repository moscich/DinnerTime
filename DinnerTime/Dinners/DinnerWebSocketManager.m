//
// Created by Marek Moscichowski on 23/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerWebSocketManager.h"
#import "DinnerArrayDTO.h"


@implementation DinnerWebSocketManager {

}

- (instancetype)init {
  self = [super init];
  if (self) {
    NSString *urlString = @"wss://192.168.1.126:8001";
    self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    self.webSocket.delegate = self;
  }

  return self;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
  DinnerArrayDTO *dinners = [[DinnerArrayDTO alloc] initWithString:message error:nil];
  [self.delegate webSocketReceivedDinners:dinners.dinners];
}


@end