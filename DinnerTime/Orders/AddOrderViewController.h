//
// Created by Marek Mościchowski on 28/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AddOrderViewControllerDelegate
- (void)addNewOrderNamed:(NSString *)title;
@end

@interface AddOrderViewController : UIViewController

@property (nonatomic, weak) id <AddOrderViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextField *orderTitleTextField;
@property (nonatomic, strong) IBOutlet UIButton *sendButton;

- (void)titleTextFieldChanged:(UITextField *)textField;

- (IBAction)sendButtonTapped;
- (IBAction)cancelButtonTapped;

@end