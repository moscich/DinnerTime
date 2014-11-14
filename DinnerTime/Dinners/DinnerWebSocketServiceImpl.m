//
// Created by Marek Moscichowski on 23/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerWebSocketServiceImpl.h"
#import "DinnerArrayDTO.h"
#import "DinnerUpdateDTO.h"
#import "DinnerWebSocketService.h"

@interface DinnerWebSocketServiceImpl()

@property(nonatomic, strong) SRWebSocket *webSocket;

@end

@implementation DinnerWebSocketServiceImpl {

}

@synthesize delegate;

- (instancetype)init {
  self = [super init];
  if (self) {
    NSString *urlString = @"wss://192.168.1.126:8001";
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