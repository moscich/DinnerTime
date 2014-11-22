//
// Created by Marek Moscichowski on 22/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "FakeGoogleManager.h"


@implementation FakeGoogleManager {

}

@synthesize delegate;

- (void)signIn {
  [self.delegate googleSignInManagerAuthenticatedInGoogleWithToken:@"Fake Token"];
}

@end