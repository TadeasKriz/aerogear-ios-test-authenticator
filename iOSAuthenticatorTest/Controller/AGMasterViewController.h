#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@class AGDetailViewController;

@interface AGMasterViewController : PullRefreshTableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) AGDetailViewController *detailViewController;

@end