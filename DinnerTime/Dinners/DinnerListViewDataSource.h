#import <UIKit/UIKit.h>

@protocol DinnerListViewDataSource <UITableViewDataSource>
- (DinnerServiceResultType)lastResultType;
@end