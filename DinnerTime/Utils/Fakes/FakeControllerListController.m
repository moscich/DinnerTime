//
// Created by Marek Moscichowski on 19/11/14.
// Copyright (c) 2014 Marek Mościchowski. All rights reserved.
//

#import <Typhoon/TyphoonAssembly.h>
#import <Typhoon/TyphoonComponentFactory.h>
#import "FakeControllerListController.h"


@implementation FakeControllerListController {

}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.viewControllers = [[self.assembly asFactory] allComponentsForType:[UIViewController class]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.navigationController pushViewController:self.viewControllers[(NSUInteger) indexPath.row] animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.viewControllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
  if(!cell){
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
  }
  cell.textLabel.text = NSStringFromClass([self.viewControllers[(NSUInteger) indexPath.row] class]);
  return cell;
}

@end