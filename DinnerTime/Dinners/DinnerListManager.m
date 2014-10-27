//
// Created by Marek Mościchowski on 27/10/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import "DinnerListManager.h"
#import "DinnerCell.h"
#import "DinnerDTO.h"
#import "DinnerManager.h"


@implementation DinnerListManager {

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.dinners.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DinnerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DinnerCellIdentifier"];
    DinnerDTO *dinner = self.dataSource.dinners[(NSUInteger) indexPath.row];
    cell.textLabel.text = dinner.title;
    cell.ownerLabel.text = dinner.owner;
    cell.ownerBackground.hidden = !dinner.owned;
    return cell;
}

@end