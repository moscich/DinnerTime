//
// Created by Marek Mościchowski on 20/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "AddDinnerViewController.h"
#import "DinnerDTO.h"


@implementation AddDinnerViewController {

}

- (void)viewDidLoad {
  [self.titleTextField addTarget:self action:@selector(titleFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendButtonTapped:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
  DinnerDTO *dinner = [DinnerDTO new];
  dinner.title = self.titleTextField.text;
  dinner.details = self.detailTextView.text;
  [self.delegate addDinnerViewControllerCreatedDinner:dinner];
}

- (void)titleFieldDidChange:(UITextField *)textField {
    self.sendButton.enabled = textField.text.length > 0 && self.detailTextView.text.length > 0;
}

- (void)textViewDidChange:(UITextView *)textView {
  self.sendButton.enabled = textView.text.length > 0 && self.titleTextField.text.length > 0;
}

@end