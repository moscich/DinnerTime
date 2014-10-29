//
// Created by Marek Moscichowski on 29/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DinnerSummaryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailsLabel;
@property (nonatomic, weak) IBOutlet UILabel *ownerLabel;
@end