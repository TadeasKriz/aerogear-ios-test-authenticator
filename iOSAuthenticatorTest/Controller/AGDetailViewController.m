#import "AGDetailViewController.h"
#import "AGStoreConfig.h"
#import "AGPushApplication.h"
#import "AGUnifiedPushAPIService.h"
#import "SVProgressHUD.h"

@interface AGDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation AGDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.idField.text = [self.detailItem recordId];
        self.pushApplicationIDField.text = [self.detailItem pushApplicationID];
        self.masterSecretField.text = [self.detailItem masterSecret];
        self.nameField.text = [self.detailItem name];
        self.descriptionField.text = [self.detailItem description];
        self.developerField.text = [self.detailItem developer];
        self.androidVariantsCountField.text = [[self.detailItem androidVariantsCount] stringValue];
        self.iosvariantsCountField.text = [[self.detailItem iosVariantsCount] stringValue];
        self.simplePushVariantsCountField.text = [[self.detailItem simplePushVariantsCount] stringValue];

        if([self.detailItem recordId] == nil) {
            [self.saveButton.titleLabel setText:@"Add"];
        } else {
            [self.saveButton.titleLabel setText:@"Save"];
        }
    }
}

- (IBAction)save:(id)sender {
    [self.detailItem setName:self.nameField.text];
    [self.detailItem setDescription:self.descriptionField.text];

    [SVProgressHUD showWithStatus:@"Saving ..." maskType:SVProgressHUDMaskTypeGradient];

    [[AGUnifiedPushAPIService sharedInstance] postApplication:self.detailItem success:^{
        [SVProgressHUD dismiss];

        [self configureView];
    } failure:^(NSError* error) {
        [SVProgressHUD dismiss];

        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];

        [alert show];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.scrollView setContentSize:self.contentView.frame.size];
    [self registerForKeyboardNotifications];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)textFieldDidBeginEditing:(UITextField*)textField {
    self.activeTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];

    return YES;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

    CGRect rect = self.view.frame;
    rect.size.height -= keyboardSize.height;
    if(!CGRectContainsPoint(rect, CGPointMake(self.activeTextField.frame.origin.x, self.activeTextField.frame.origin.y + self.activeTextField.frame.size.height))) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeTextField.frame.origin.y + self.activeTextField.frame.size.height - keyboardSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end