//
// Created by Marek Moscichowski on 09/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, weak) IBOutlet UIButton *signInButton;

@end