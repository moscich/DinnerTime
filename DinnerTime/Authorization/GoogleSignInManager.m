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

}


@end