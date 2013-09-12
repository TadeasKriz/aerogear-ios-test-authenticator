#import "AGLoginViewController.h"
#import "SVProgressHUD.h"
#import "AGUnifiedPushAPIService.h"
#import "AGMasterViewController.h"

@implementation AGLoginViewController {

}

@synthesize usernameField;
@synthesize passwordField;
@synthesize scrollView;
@synthesize activeTextField;


- (void)viewDidLoad {
    [self registerForKeyboardNotifications];
}

- (IBAction)login:(id)sender {

    if(usernameField.text.length == 0 || passwordField.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Please enter your username and password!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    [SVProgressHUD showWithStatus:@"Logging in ..." maskType:SVProgressHUDMaskTypeGradient];

    [AGUnifiedPushAPIService
            initSharedInstanceWithBaseURL:@"https://agpushmedium-arqtest.rhcloud.com/rest"
                                 username:usernameField.text
                                 password:passwordField.text
                                  success:^{
                                      [SVProgressHUD dismiss];
                                      UINavigationController* navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
                                      [self presentViewController:navigationController animated:YES completion:nil];
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

- (IBAction)skipLogin:(id)sender {
    [SVProgressHUD showWithStatus:@"Logging in ..." maskType:SVProgressHUDMaskTypeGradient];

    [AGUnifiedPushAPIService
            initSharedInstanceWithBaseURL:@"https://agpushmedium-arqtest.rhcloud.com/rest"
                                  success:^{
                                      [SVProgressHUD dismiss];

                                      UINavigationController* navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
                                      [self presentViewController:navigationController animated:YES completion:nil];
                                  }
                                  failure:^(NSError* error) {
                                      [SVProgressHUD dismiss];

                                      UIAlertView* alert = [[UIAlertView alloc]
                                              initWithTitle:@"Oops!"
                                                    message:[error localizedDescription]
                                                   delegate:nil cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];

                                      [alert show];
                                  }];
}

- (void)textFieldDidBeginEditing:(UITextField*)textField {
    activeTextField = textField;
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
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;

    CGRect rect = self.view.frame;
    rect.size.height -= keyboardSize.height;
    if(!CGRectContainsPoint(rect, CGPointMake(activeTextField.frame.origin.x, activeTextField.frame.origin.y + activeTextField.frame.size.height))) {
        CGPoint scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y - keyboardSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

@end