//
// Created by Marek Mościchowski on 14/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DinnerWebSocketServiceDelegate
- (void)webSocketReceivedDinnerUpdate:(NSNumber *)dinnerID;
@end

@protocol DinnerWebSocketService <NSObject>
@property(nonatomic, strong) id <DinnerWebSocketServiceDelegate> delegate;
@end

