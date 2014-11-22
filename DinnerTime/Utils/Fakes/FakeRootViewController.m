//
// Created by Marek Moscichowski on 19/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Typhoon/TyphoonAssembly.h>
#import "FakeRootViewController.h"


@implementation FakeRootViewController {

}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.view addSubview:self.navigationController.view];
  UIView *navigationView = self.navigationController.view;
  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[navigationView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(navigationView)];
  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(navigationView)];
}

@end