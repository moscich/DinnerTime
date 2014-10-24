//
// Created by Marek Moscichowski on 23/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@class SRWebSocket;

@protocol DinnerWebSocketManagerDelegate
- (void)webSocketReceivedDinnerUpdate:(NSNumber *)dinnerID;
@end

@interface DinnerWebSocketManager : NSObject<SRWebSocketDelegate>
@property(nonatomic, strong) SRWebSocket *webSocket;
@property(nonatomic, strong) id <DinnerWebSocketManagerDelegate> delegate;

@end