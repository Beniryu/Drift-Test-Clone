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

#import "DFTOptionTableViewCell.h"
#import "DFTDropSignalViewController.h"


@interface DFTDropFormViewController () <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *completionView;

@property (weak, nonatomic) IBOutlet DFTDropFormFirstStepView *firstStepContainer;
@property (weak, nonatomic) IBOutlet UITableView *stepTwoTableView;

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

	self.navigationController.navigationBarHidden = YES;

	UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
	UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];

	swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	swipeUp.delegate = self;
	swipeDown.delegate = self;

	[self.view addGestureRecognizer:swipeUp];
	[self.view addGestureRecognizer:swipeDown];
	[self configureScrollView];
	[self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[UIView animateWithDuration:1 animations:^{
		self.completionView.transform = CGAffineTransformMakeTranslation(0, -(self.completionView.frame.size.height * 0.6));
	}];
	[self.firstStepContainer appear];
}

- (void)configureScrollView
{
//	self.scrollView.delegate = self;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollEnabled = NO;
}

- (void)configureTableView
{
	self.stepTwoTableView.delegate = self;
	self.stepTwoTableView.dataSource = self;
	self.stepTwoTableView.scrollEnabled = NO;
	self.stepTwoTableView.rowHeight = UITableViewAutomaticDimension;
	self.stepTwoTableView.estimatedRowHeight = 44.;
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
		self.scrollView.contentOffset = (CGPoint){0, self.scrollView.contentOffset.y + 350};

		CGAffineTransform t = self.completionView.transform;
		self.completionView.transform = CGAffineTransformTranslate(t, 0, self.completionView.frame.size.height * 0.4);
	}];
}

- (void)transitionFromSettingsToValidation
{
	[UIView animateWithDuration:1 animations:^{
		self.scrollView.contentOffset = (CGPoint){0, self.scrollView.contentOffset.y + 200};

		CGAffineTransform t = self.completionView.transform;
		self.completionView.transform = CGAffineTransformIdentity;
	}];
}

- (void)transitionFromValidationToSettings
{
	[UIView animateWithDuration:1 animations:^{
		self.scrollView.contentOffset = (CGPoint){0, self.scrollView.contentOffset.y - 200};

		self.completionView.transform = CGAffineTransformMakeTranslation(0, -(self.completionView.frame.size.height * 0.2));
	}];
}

- (void)transitionFromSettingsToDetails
{
	[self.firstStepContainer animateReverse];
	[UIView animateWithDuration:1 animations:^{
		self.scrollView.contentOffset = (CGPoint){0, self.scrollView.contentOffset.y - 350};

		CGAffineTransform t = self.completionView.transform;
		self.completionView.transform = CGAffineTransformTranslate(t, 0, -(self.completionView.frame.size.height * 0.4));
	}];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (5);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DFTOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optionCell" forIndexPath:indexPath];

	[cell configureWithIndexPath:indexPath];
	return (cell);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
	{
		DFTDropSignalViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([DFTDropSignalViewController class])];

		[self.navigationController pushViewController:controller animated:YES];
	}
}
@end
