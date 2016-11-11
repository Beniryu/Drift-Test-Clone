//
//  ViewController.m
//  Drift
//
//  Created by Thierry Ng on 09/11/16.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTLoginViewController.h"

#import "DFTRoundedButton.h"
#import "UIColor+DFTStyles.h"

@interface DFTLoginViewController ()

#pragma mark Alternative login buttons
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
}

- (void)configureViews
{
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

@end