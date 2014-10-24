//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <GoogleOpenSource/GoogleOpenSource.h>
#import "GoogleSignInManager.h"

@implementation GoogleSignInManager {

}
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
  [self.delegate googleSignInManagerAuthenticatedInGoogleWithToken:auth.accessToken];
}

- (void)signIn {
    self.googleSignIn = [GPPSignIn sharedInstance];
  self.googleSignIn.shouldFetchGooglePlusUser = YES;
  self.googleSignIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
  self.googleSignIn.shouldFetchGoogleUserID = YES;  // Uncomment to get the user's email

  // You previously set kClientId in the "Initialize the Google+ client" step
  self.googleSignIn.clientID = @"1027649705449-pa7i2thrkubbkel0npe7ru7n53uql362.apps.googleusercontent.com";

  // Uncomment one of these two statements for the scope you chose in the previous step
//  signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
  self.googleSignIn.scopes = @[ @"profile" ];            // "profile" scope

  // Optional: declare signIn.actions, see "app activities"
  self.googleSignIn.delegate = self;

  [[GPPSignIn sharedInstance] authenticate];
}

- (void)logout {
    [self.googleSignIn disconnect];
}

@end