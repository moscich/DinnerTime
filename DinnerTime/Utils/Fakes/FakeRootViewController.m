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
  [navigationView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(60)-[navigationView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(navigationView)]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(navigationView)]];
}

@end