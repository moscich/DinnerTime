//
// Created by Marek Moscichowski on 05/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlus/GooglePlus.h>

@protocol GoogleSignInManagerDelegate
- (void)googleSignInManagerAuthenticatedInGoogleWithToken:(NSString *)token;
@end

@interface GoogleSignInManager : NSObject <GPPSignInDelegate>
@property(nonatomic, weak) id <GoogleSignInManagerDelegate> delegate;

- (void)signIn;
@end