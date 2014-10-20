//
// Created by Marek Mościchowski on 20/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DinnerDTO;

@protocol AddDinnerViewControllerDelegate
- (void)addDinnerViewControllerCreatedDinner:(DinnerDTO *)dinnerDTO;
@end

@interface AddDinnerViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITextField *titleTextField;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;

@property(nonatomic, strong) id <AddDinnerViewControllerDelegate> delegate;

- (IBAction)cancelButtonTapped;
- (IBAction)sendButtonTapped:(id)sender;

- (void)titleFieldDidChange:(UITextField *)textField;
@end
