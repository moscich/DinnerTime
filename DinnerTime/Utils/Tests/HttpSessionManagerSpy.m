//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "HttpSessionManagerSpy.h"
#import "DinnerServiceResultType.h"


@implementation HttpSessionManagerSpy {

}

- (id)initWithReturnType:(DinnerServiceResultType)type {
  self = [super init];
  if (self) {
    self.returnType = type;
  }

  return self;
}

- (instancetype)initWithResultData:(NSData *)resultData {
  self = [super init];
  if (self) {
    self.resultData = resultData;
    self.returnType = DinnerServiceResult_Success;
  }

  return self;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  self.parameters = parameters;
  self.calledAddress = URLString;
  success(nil, self.resultData);
  return nil;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  switch(self.returnType){
    case DinnerServiceResult_Success:{

      success(nil, self.resultData);
      break;
    }
    case DinnerServiceResult_Unauthorized:{
      NSError *error = [[NSError alloc] initWithDomain:@"" code:401 userInfo:nil];
      failure(nil, error);
      break;
    }
    default:break;
  }

  self.calledAddress = URLString;
  return nil;
}

@end