//
//  ViewController.m
//  Drift
//
//  Created by Thierry Ng on 09/11/16.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTLoginViewController.h"

@interface DFTLoginViewController ()

#pragma mark Alternative login buttons

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIButton *numberButton;
@property (weak, nonatomic) IBOutlet UIButton *fingerprintButton;

#pragma mark Text Fields
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation DFTLoginViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self configureViews];
}

- (void)configureViews
{
	[self.facebookButton setImage:[UIImage imageNamed:@"facebook_icon"] forState:UIControlStateNormal];
	[self.googleButton setImage:[UIImage imageNamed:@"google_icon"] forState:UIControlStateNormal];


	self.facebookButton.tintColor = [UIColor colorWithRed:0.60 green:0.69 blue:0.79 alpha:1.0];;
	self.googleButton.tintColor = [UIColor colorWithRed:0.60 green:0.69 blue:0.79 alpha:1.0];;
	self.emailTextField.userInteractionEnabled = NO;
	self.passwordTextField.userInteractionEnabled = NO;
}

@end