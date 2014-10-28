//
// Created by Marek Mościchowski on 28/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "AddOrderViewController.h"


@implementation AddOrderViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.orderTitleTextField addTarget:self action:@selector(titleTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)titleTextFieldChanged:(UITextField *)textField{
    self.sendButton.enabled = textField.text.length > 0;
}

- (IBAction)sendButtonTapped{
    [self.delegate addNewOrderNamed:self.orderTitleTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonTapped{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end