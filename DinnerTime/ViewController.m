//
//  ViewController.m
//  DinnerTime
//
//  Created by Marek Moscichowski on 25/09/14.
//  Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <GoogleOpenSource/GoogleOpenSource.h>
#import "ViewController.h"
#import "AFSecurityPolicy.h"
#import "AFHTTPSessionManager.h"
#import <Security/Security.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  GPPSignIn *signIn = [GPPSignIn sharedInstance];
  [signIn signOut];
  signIn.shouldFetchGooglePlusUser = YES;
  signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
  signIn.shouldFetchGoogleUserID = YES;  // Uncomment to get the user's email

  // You previously set kClientId in the "Initialize the Google+ client" step
  signIn.clientID = @"1027649705449-pa7i2thrkubbkel0npe7ru7n53uql362.apps.googleusercontent.com";

  // Uncomment one of these two statements for the scope you chose in the previous step
//  signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
  signIn.scopes = @[ @"profile" ];            // "profile" scope

  // Optional: declare signIn.actions, see "app activities"
  signIn.delegate = self;


  NSURL *URL = [NSURL URLWithString:@"https://192.168.1.126/dinners"];
  AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
  manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
  manager.securityPolicy.allowInvalidCertificates = YES;
  [manager.requestSerializer setValue:@"29f05060-4a7d-11e4-979f-c7bf5ffae6cf" forHTTPHeaderField:@"session_id"];
  [manager GET:@"/dinners" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"responseObject = %@", responseObject);

  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"DUPA");
    NSLog(@"error = %@", error);
  }];

//  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] init];
//
//
//
//  [operation setSSLPinningMode:AFSSLPinningModeCertificate];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
  NSLog(@"Received error %@ and auth object %@",error, auth);
  NSString *string = [[GPPSignIn sharedInstance] userEmail];
  NSLog(@"string = %@", string);
}

- (void)presentSignInViewController:(UIViewController *)viewController {
  // This is an example of how you can implement it if your app is navigation-based.
  [[self navigationController] pushViewController:viewController animated:YES];
}

@end
