//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerTimeService.h"
#import "UICKeyChainStore.h"
#import "DinnerSessionBuilder.h"
#import "DinnerSessionManager.h"
#import "SessionDTO.h"
#import "DinnerArrayDTO.h"
#import "DinnerDTO.h"

@implementation DinnerTimeService {

}

- (id)initWithDinnerSessionBuilder:(DinnerSessionBuilder *)dinnerSessionBuilder {
  self = [super init];
  if (self) {
    self.dinnerSessionManager = [dinnerSessionBuilder constructSessionManager];
    self.dinnerSessionManager.sessionId = [UICKeyChainStore stringForKey:@"session_id"];
  }

  return self;
}

- (void)logout:(void (^)(DinnerServiceResultType))callback {
  [self.dinnerSessionManager POST:@"/logout" parameters:nil success:^(NSString *string) {
    callback(DinnerServiceResult_Success);
  } failure:^(NSError *error) {

  }];
}

- (void)loginWithToken:(NSString *)token withCallback:(void (^)(NSString *sessionId))callback {
  [self.dinnerSessionManager POST:@"/login" parameters:@{@"token":token} success:^(NSString *string) {
    SessionDTO *sessionDTO = [[SessionDTO alloc] initWithString:string error:nil];
    [UICKeyChainStore setString:sessionDTO.sessionId forKey:@"session_id"];
    self.dinnerSessionManager.sessionId = sessionDTO.sessionId;
    callback(sessionDTO.sessionId);
  } failure:nil];
}

- (void)getDinners:(void (^)(NSArray *))callback failure:(void (^)(DinnerServiceResultType))failure {
  [self.dinnerSessionManager GET:@"/dinners" parameters:nil success:^(NSString *string) {
    JSONModelError *error;
    DinnerArrayDTO *dinnerArrayDTO = [[DinnerArrayDTO alloc] initWithString:string error:&error];
    callback(dinnerArrayDTO.dinners);
  } failure:^(NSError *error) {
    if([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401)
      failure(DinnerServiceResult_Unauthorized);
  }];
}

- (void)postDinner:(DinnerDTO *)dinner withCallback:(void (^)(DinnerDTO *))callback {
  [self.dinnerSessionManager POST:@"/dinners" parameters:@{@"title":dinner.title} success:^(NSString *string) {
    JSONModelError *error;
      DinnerDTO *dto = [[DinnerDTO alloc] initWithString:string error:&error];
      callback(dto);
  } failure:nil];
}
@end