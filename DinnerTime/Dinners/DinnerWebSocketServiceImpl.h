//
// Created by Marek Moscichowski on 23/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#include "DinnerWebSocketService.h"

@class SRWebSocket;

@interface DinnerWebSocketServiceImpl : NSObject<SRWebSocketDelegate, DinnerWebSocketService>

@end