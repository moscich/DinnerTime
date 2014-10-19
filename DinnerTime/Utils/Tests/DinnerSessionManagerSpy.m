//
// Created by Marek Moscichowski on 11/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerSessionManagerSpy.h"
#import "DinnerServiceResultType.h"


@implementation DinnerSessionManagerSpy {

}
- (id)initWithResultType:(DinnerServiceResultType)type {
  self = [super init];
  if(self){
    self.returnType = type;
  }
  return self;
}

- (id)initWithDinnerJSON:(NSString *)jsonString {
  self = [super init];
  if(self){
    self.dinnerJSON = jsonString;
  }
  return self;
}

- (id)initWithSessionJSON:(NSString *)sessionJSON {
  self = [super init];
  if(self){
    self.sessionJSON = sessionJSON;
  }
  return self;
}

- (void)POST:(NSString *)string parameters:(NSDictionary *)parameters success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure {
  self.parameters = parameters;
  self.postCalledAddress =  string;
  success(self.sessionJSON);
}

- (void)GET:(NSString *)string parameters:(NSDictionary *)parameters success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure {
  self.getCalledAddress = string;
  if(self.returnType == DinnerServiceResult_Unauthorized){
    NSHTTPURLResponse *mockResponse = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:401 HTTPVersion:nil headerFields:nil];
    NSError *error = [[NSError alloc] initWithDomain:@"" code:-1011 userInfo:@{AFNetworkingOperationFailingURLResponseErrorKey:mockResponse}];
    failure(error);
  }else
    success(self.dinnerJSON);
}

@end