#import "AGMasterViewController.h"

#import "AGDetailViewController.h"
#import "AGUnifiedPushAPIService.h"
#import "AGPushApplication.h"
#import "SVProgressHUD.h"

@interface AGMasterViewController () {
    NSMutableArray* _allApplications;
}
@end

@implementation AGMasterViewController

- (void)awakeFromNib {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem* logoutButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                  target:self
                                                                                  action:@selector(logout:)];

    self.navigationItem.leftBarButtonItems = @[ logoutButton, self.editButtonItem ];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;

    self.detailViewController = (AGDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        AGPushApplication* application = [AGPushApplication alloc];
        self.detailViewController.detailItem = application;
    } else {
        AGDetailViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AGDetailViewController"];
        controller.detailItem = [AGPushApplication alloc];
        [self.navigationController pushViewController:controller animated:YES];
    }

/*    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];*/
}

-(void)logout:(id)sender {
    [SVProgressHUD showWithStatus:@"Logging out ..." maskType:SVProgressHUDMaskTypeGradient];

    [[AGUnifiedPushAPIService sharedInstance] logout:^{
        [SVProgressHUD dismiss];
    } failure:^(NSError* error) {
        [SVProgressHUD dismiss];

        UIAlertView* alert = [[UIAlertView alloc]
                initWithTitle:@"Oops!"
                      message:[error localizedDescription]
                     delegate:nil
            cancelButtonTitle:@"Ok"
            otherButtonTitles:nil];

        [alert show];
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allApplications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellApplicationIdentifier" forIndexPath:indexPath];

    AGPushApplication* application = [_allApplications objectAtIndex:indexPath.row];
    cell.textLabel.text = [application name];


    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIActionSheet* yesno = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete it?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No, cancel"
                                             destructiveButtonTitle:@"Yes, delete"
                                                  otherButtonTitles:nil];
        yesno.tag = indexPath.row;

        [yesno showInView:self.navigationController.toolbar];

 //       [_objects removeObjectAtIndex:indexPath.row];
 //       [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        NSUInteger row = [actionSheet tag];

        AGPushApplication* application = [_allApplications objectAtIndex:row];

        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];

        [[AGUnifiedPushAPIService sharedInstance] removeApplication:application
                                                            success:^{
                                                                [SVProgressHUD showSuccessWithStatus:@"Successfully deleted!"];

                                                                [_allApplications removeObject:application];

                                                                NSArray* paths = [NSArray arrayWithObject:
                                                                        [NSIndexPath indexPathForRow:row inSection:0]];

                                                                [[self tableView] deleteRowsAtIndexPaths:paths
                                                                                        withRowAnimation:UITableViewRowAnimationTop];

                                                            }
                                                            failure:^(NSError* error) {
                                                                [SVProgressHUD dismiss];

                                                                UIAlertView* alert = [[UIAlertView alloc]
                                                                        initWithTitle:@"Oops!"
                                                                              message:[error localizedDescription]
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"Ok"
                                                                    otherButtonTitles:nil];

                                                                [alert show];
                                                            }];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        AGPushApplication* application = _allApplications[indexPath.row];
        self.detailViewController.detailItem = application;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AGPushApplication* application = _allApplications[indexPath.row];
        [[segue destinationViewController] setDetailItem:application];

//        NSDate *object = _objects[indexPath.row];
//        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark PullToRefresh action

- (void)refresh {
    [[AGUnifiedPushAPIService sharedInstance] fetchApplications:^(NSMutableArray* applications) {
        _allApplications = applications;

        [self stopLoading];

        [self.tableView reloadData];
    } failure:^(NSError* error) {
        [self stopLoading];

        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];

        [alert show];
    }];
}

@end