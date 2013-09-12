#import <UIKit/UIKit.h>

@interface AGDetailViewController : UIViewController <UISplitViewControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UITextField *idField;
@property (weak, nonatomic) IBOutlet UITextField *pushApplicationIDField;
@property (weak, nonatomic) IBOutlet UITextField *masterSecretField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *developerField;
@property (weak, nonatomic) IBOutlet UITextField *androidVariantsCountField;
@property (weak, nonatomic) IBOutlet UITextField *iosvariantsCountField;
@property (weak, nonatomic) IBOutlet UITextField *simplePushVariantsCountField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) UITextField* activeTextField;

- (IBAction)save:(id)sender;
@end