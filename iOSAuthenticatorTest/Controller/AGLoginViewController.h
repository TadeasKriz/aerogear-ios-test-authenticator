#import <UIKit/UIKit.h>


@interface AGLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField* usernameField;
@property (weak, nonatomic) IBOutlet UITextField* passwordField;
@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;

@property (weak, nonatomic) UITextField* activeTextField;

- (IBAction)login:(id)sender;
- (IBAction)skipLogin:(id)sender;


@end