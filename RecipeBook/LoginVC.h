//
//  LoginVC.h
//  RecipeBook
//
//  Created by Miguel Ángel Rodríguez Álvarez Icaza on 6/5/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginVC : UIViewController 

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *loginUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordField;

@property (weak, nonatomic) IBOutlet UILabel *orLabel;

@property (weak, nonatomic) IBOutlet UIView *loginOverlayView;
@property (weak, nonatomic) IBOutlet UIView *registerOverlayView;

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *registerUser;
@property (weak, nonatomic) IBOutlet UIButton *alreadyButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelRegister;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;

- (IBAction)registerAction:(id)sender;
- (IBAction)registerUser:(id)sender;
- (IBAction)registeredButton:(id)sender;
- (IBAction)loginButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)cancelRegister:(id)sender;
- (IBAction)forget:(id)sender;

@end
