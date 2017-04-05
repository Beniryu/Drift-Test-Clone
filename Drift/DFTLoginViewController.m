//
//  ViewController.m
//  Drift
//
//  Created by Thierry Ng on 09/11/16.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTLoginViewController.h"

#import "DFTSessionManager.h"
#import "DFTUserManager.h"
#import "DFTRoundedButton.h"
#import "UIColor+DFTStyles.h"

@interface DFTLoginViewController () <UITextFieldDelegate>

#pragma mark Alternative login buttons
@property (weak, nonatomic) IBOutlet UILabel *alternativeLoginLabel;
@property (weak, nonatomic) IBOutlet DFTRoundedButton *facebookButton;
@property (weak, nonatomic) IBOutlet DFTRoundedButton *googleButton;
@property (weak, nonatomic) IBOutlet DFTRoundedButton *numberButton;
@property (weak, nonatomic) IBOutlet DFTRoundedButton *fingerprintButton;

#pragma mark Text Fields
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

#pragma mark Form Buttons
@property (weak, nonatomic) IBOutlet DFTRoundedButton *signUpButton;
@property (weak, nonatomic) IBOutlet DFTRoundedButton *loginButton;

@end

@implementation DFTLoginViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self configureViews];
    
    [self authenticateUser];
}

- (void)configureViews
{
	self.emailTextField.text = @"ng.thierry.d@gmail.com";
	self.passwordTextField.text = @"driftapi";

	self.emailTextField.delegate = self;
	self.passwordTextField.delegate = self;
	self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.passwordTextField.secureTextEntry = YES;

	self.alternativeLoginLabel.text = @"OR CONNECT WITH";
	self.alternativeLoginLabel.textColor = [UIColor dft_slateBlueColor];

	[self configureAlternativeButtons];
	[self configureFormButtons];
}

- (void)configureFormButtons
{
	[self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
	[self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
	self.signUpButton.style = kDFTRoundedButtonStyleRed;
	self.loginButton.style = kDFTRoundedButtonStyleAqua;
}

- (void)configureAlternativeButtons
{
	// Styles
	self.facebookButton.style = kDFTRoundedButtonStyleBordered;
	self.googleButton.style = kDFTRoundedButtonStyleBordered;
	self.numberButton.style = kDFTRoundedButtonStyleBordered;
	self.fingerprintButton.style = kDFTRoundedButtonStyleBordered;

	// Images
	[self.facebookButton setImage:[UIImage imageNamed:@"facebook_icon"] forState:UIControlStateNormal];
	[self.googleButton setImage:[UIImage imageNamed:@"google_icon"] forState:UIControlStateNormal];
}

#pragma mark
#pragma mark - Actions

- (IBAction)didTouchLoginButton:(DFTRoundedButton *)sender
{
	[self authenticateUser];
}

- (IBAction)didTouchSignUpButton:(DFTRoundedButton *)sender
{
	[self testCreate];
}

#pragma mark
#pragma mark - Helpers

- (void)testCreate
{
	DFTUserManager *manager = [DFTUserManager new];
	DFTUser *user = [DFTUser new];

	user.userId = @"0";
	user.identifier = @"ecthelz@gmail.com";
	user.email = @"ecthelz@gmail.com";
	user.lastName = @"UserCreateLast";
	user.firstName = @"UserCreateFirst";
	user.registration = [NSDate date];
	user.lastConnection = [NSDate date];

	[manager createUser:user
		 withCompletion:^(id  _Nullable responseObject, NSError * _Nullable error)
	{
		if (error)
		{
			NSLog(@"Error creating User : %@\nError : %@", user, error);
		}
		else
		{
			NSLog(@"Login OK : %@", responseObject);
		}
	}];
}

- (void)testEdit
{
	DFTUserManager *manager = [DFTUserManager new];
	DFTUser *user = [DFTSessionManager currentSession].user;

	user.firstName = @"Test Modif";
	[manager editUser: user
	   withCompletion:^(id  _Nullable responseObject, NSError * _Nullable error)
	{
		if (error)
		{
			NSLog(@"user edit not ok");
		}
		NSLog(@"user edit ok");
	}];
}

- (void)authenticateUser
{
	DFTSessionManager *manager = [DFTSessionManager currentSession];

	[manager createSessionTokenForUser:self.emailTextField.text
						  withPassword:self.passwordTextField.text autoLogin:NO
							completion:^(id  _Nullable responseObject, NSError * _Nullable error)
	 {
		 if (error)
		{
			NSLog(@"Login not ok");
		}
		else
		{
			UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
			[UIApplication sharedApplication].delegate.window.rootViewController =  [mainStoryBoard instantiateViewControllerWithIdentifier:@"DriftEntry"];
			NSLog(@"Login OK");
		}
	}];
}

#pragma mark
#pragma mark - UITextField Protocol

@end
