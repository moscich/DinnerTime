//
// Created by Marek Moscichowski on 06/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "GoogleSignInManagerStub.h"


@implementation GoogleSignInManagerStub {

}

- (void)signIn {
  [self.delegate googleSignInManagerAuthenticatedInGoogleWithToken:@"TestToken"];
}

@end