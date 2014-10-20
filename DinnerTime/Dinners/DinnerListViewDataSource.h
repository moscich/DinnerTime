#import <UIKit/UIKit.h>

@protocol DinnerListViewDataSource <UITableViewDataSource>
@property(nonatomic, assign) BOOL needUpdate;
@end