//
//  DFTDropFormViewController.m
//  Drift
//
//  Created by Thierry Ng on 02/06/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDropFormManager.h"
#import "DFTDropFormViewController.h"

#import "DFTDropFormFirstStepView.h"

@interface DFTDropFormViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *completionView;

@property (weak, nonatomic) IBOutlet DFTDropFormFirstStepView *firstStepContainer;

@property (nonatomic) DFTDropFormManager *manager;
@property (nonatomic) NSInteger currentSection;

@end

@implementation DFTDropFormViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		self.manager = [DFTDropFormManager new];
		self.currentSection = 0;
	}
	return (self);
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
	UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];

	swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	swipeUp.delegate = self;
	swipeDown.delegate = self;

	[self.view addGestureRecognizer:swipeUp];
	[self.view addGestureRecognizer:swipeDown];
	[self configureScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	CGRect frame = self.completionView.frame;

	[UIView animateWithDuration:0.7 animations:^{
		self.completionView.transform = CGAffineTransformMakeTranslation(0, -(667. * 0.6));
	}];
	[self.firstStepContainer appear];
}

- (void)configureScrollView
{
//	self.scrollView.delegate = self;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollEnabled = NO;
}

- (void)swipeUp:(UISwipeGestureRecognizer *)sender
{
	DFTDropFormTransitionBlock block = nil;

	block = ^(kDFTDropFormStepTransition transition) {
		[self executeTransition:transition];
	};

	self.currentSection = [self.manager routeSwipeDirection:kDFTDropFormSwipeDirectionUp
												fromSection:self.currentSection
												  withBlock:block];
}

- (void)swipeDown:(UISwipeGestureRecognizer *)sender
{
	DFTDropFormTransitionBlock block = nil;

	block = ^(kDFTDropFormStepTransition transition) {
		[self executeTransition:transition];
	};

	self.currentSection = [self.manager routeSwipeDirection:kDFTDropFormSwipeDirectionDown
												fromSection:self.currentSection
												  withBlock:block];
}

- (void)executeTransition:(kDFTDropFormStepTransition)transition
{
	//	self.currentStep = transition;
	switch (transition)
	{
		case kDFTDropFormStepTransitionDetailsToSettings:
			[self transitionFromDetailsToSettings];
			break;
		case kDFTDropFormStepTransitionSettingsToValidation:
			[self transitionFromSettingsToValidation];
			break;
		case kDFTDropFormStepTransitionValidationToSettings:
			[self transitionFromValidationToSettings];
			break;
		case kDFTDropFormStepTransitionSettingsToDetails:
			[self transitionFromSettingsToDetails];
			break;
	}
}

- (void)transitionFromDetailsToSettings
{
	[self.firstStepContainer animateForward];
	[UIView animateWithDuration:1 animations:^{
		self.scrollView.contentOffset = (CGPoint){0, self.scrollView.contentOffset.y + 150};
	}];
}

- (void)transitionFromSettingsToValidation
{

}

- (void)transitionFromValidationToSettings
{

}

- (void)transitionFromSettingsToDetails
{
	[self.firstStepContainer animateReverse];
	[UIView animateWithDuration:1 animations:^{
		self.scrollView.contentOffset = (CGPoint){0, self.scrollView.contentOffset.y - 150};
	}];
}

@end
