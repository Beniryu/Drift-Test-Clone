//
//  DFTDropFormViewController.m
//  Drift
//
//  Created by Thierry Ng on 02/06/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDropFormManager.h"
#import "DFTDropFormViewController.h"


#import "DFTMapManager.h"
#import "DFTOptionTableViewCell.h"
#import "DFTDropSignalViewController.h"
#import "DFTDropManager.h"
#import "DFTDropFormViewController+DFTDropFormCamera.h"

@interface DFTDropFormViewController () <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *completionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstStepHeight;
@property (weak, nonatomic) IBOutlet UITableView *stepTwoTableView;

@property (weak, nonatomic) IBOutlet UIView *saveButton;

@property (nonatomic) DFTDropFormManager *manager;
@property (nonatomic) NSInteger currentSection;
@property (nonatomic) BOOL firstAppearance;

@end

@implementation DFTDropFormViewController

- (instancetype)init {
	if (self = [super init])
		[self commonInit];
	return (self);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder])
		[self commonInit];
	return (self);
}

- (void)commonInit
{
	self.manager = [DFTDropFormManager new];
	self.currentSection = 0;
	self.firstAppearance = YES;
	self.firstStepContainer.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.navigationController.navigationBarHidden = YES;

	UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(launchCamera:)];

	[self.cameraHandle addGestureRecognizer:swipe];
	swipe.delegate = self;

	UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
	UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];

	swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
	swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
	swipeUp.delegate = self;
	swipeDown.delegate = self;

	self.firstStepHeight.constant = self.view.frame.size.height - 83;
	[self.view addGestureRecognizer:swipeUp];
	[self.view addGestureRecognizer:swipeDown];
	[self configureScrollView];
	[self configureTableView];
	[self configureCameraActions];

	self.cameraButton.hidden = YES;
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePicture)];
	[self.cameraButton addGestureRecognizer:tap];

	UITapGestureRecognizer *saveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveDrop)];
	[self.saveButton addGestureRecognizer:saveTap];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if (self.firstAppearance)
	{
		[UIView animateWithDuration:1 animations:^{
			self.completionView.transform = CGAffineTransformMakeTranslation(0, -(self.completionView.frame.size.height * 0.6));
		}];
		[self.firstStepContainer appear];
		self.firstAppearance = NO;
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	NSLog(@"View Did Appear");
}

- (void)configureScrollView {
	//	self.scrollView.delegate = self;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollEnabled = NO;
}

- (void)configureTableView {
	self.stepTwoTableView.delegate = self;
	self.stepTwoTableView.dataSource = self;
	self.stepTwoTableView.scrollEnabled = NO;
	self.stepTwoTableView.rowHeight = UITableViewAutomaticDimension;
	self.stepTwoTableView.estimatedRowHeight = 44.;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return (NO);
}

- (void)saveDrop
{
	DFTDropManager *manager = [DFTDropManager new];

	DFTDrop *drop = [DFTDrop new];

	drop.dropDate = [NSDate new];
	[self.firstStepContainer fillDrop:drop];
	drop.backgroundPicture = self.imageData;
	drop.latitude = [DFTMapManager sharedInstance].mapView.userLocation.location.coordinate.latitude;
	drop.longitude = [DFTMapManager sharedInstance].mapView.userLocation.location.coordinate.longitude;

	[manager createDrop:drop withCompletion:^(id  _Nullable responseObject, NSError * _Nullable error) {
		if (error == nil)
			[self dismissViewControllerAnimated:YES completion:nil];
	}];
}

- (void)launchCamera:(UIPanGestureRecognizer *)sender
{
	CGPoint point = [sender locationInView:self.view];

	//	NSLog(@"Point : %f", point.y);
	if (sender.state == UIGestureRecognizerStateBegan)
	{
		if (point.y >= 170.0)
		{
			[UIView animateWithDuration:0.5 animations:^{
				self.cameraHandle.alpha = 0;
				self.scrollView.contentOffset = (CGPoint){0, -240.};
			} completion:^(BOOL finished) {
				self.cameraButton.alpha = 1;
				self.cameraButton.hidden = NO;
			}];
			[self.firstStepContainer arrangeForCamera];

			[self configureCapture];
		}
	}
}

- (void)swipeUp:(UISwipeGestureRecognizer *)sender
{
	if (self.cameraButton.hidden == NO)
	{
		[self dismissCamera:YES];
		return ;
	}
	DFTDropFormTransitionBlock block = nil;

	block = ^(kDFTDropFormStepTransition transition) {
		[self executeTransition:transition];
	};

	self.cameraButton.hidden = YES;
	self.cameraHandle.alpha = 1;
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

	self.cameraButton.hidden = YES;
	self.currentSection = [self.manager routeSwipeDirection:kDFTDropFormSwipeDirectionDown
												fromSection:self.currentSection
												  withBlock:block];
}

- (void)executeTransition:(kDFTDropFormStepTransition)transition
{
	// self.currentStep = transition;

	NSLog(@"%ld", (long)transition);
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

- (void)transitionFromDetailsToSettings // 01 -> 02
{
	[self.firstStepContainer animateForward];

	// Scrolling + completion bar
	[UIView animateWithDuration:1 animations:^{
		self.scrollView.contentOffset = (CGPoint){0, self.scrollView.contentOffset.y + 350};

		CGAffineTransform t = self.completionView.transform;
		self.completionView.transform = CGAffineTransformTranslate(t, 0, self.completionView.frame.size.height * 0.4);
	}];

	// Step 02 table view
//	[UIView animateWithDuration:0.6 delay:0.4 options:UIViewAnimationOptionTransitionNone animations:^{
//		self.stepTwoTableView.transform = CGAffineTransformMakeTranslation(0, -40);
//	} completion:nil];
}

- (void)transitionFromSettingsToValidation // 02 -> 03
{
	// Scrolling + completion bar
	[UIView animateWithDuration:1 animations:^{
		self.scrollView.contentOffset = (CGPoint){0, self.scrollView.contentOffset.y + 200};
		self.completionView.transform = CGAffineTransformIdentity;
	}];

	// Tableview shenaningans
	[UIView animateWithDuration:0.3 animations:^{
		self.stepTwoTableView.alpha = 0;
	} completion:^(BOOL finished) {
		[self.stepTwoTableView reloadData];
		[UIView animateWithDuration:0.4 animations:^{
			self.stepTwoTableView.alpha = 1;
		}];
	}];
}

- (void)transitionFromValidationToSettings // 03 -> 02
{
	// Scrolling + completion bar
	[UIView animateWithDuration:1 animations:^{
		self.scrollView.contentOffset = (CGPoint){0, self.scrollView.contentOffset.y - 200};
		self.completionView.transform = CGAffineTransformMakeTranslation(0, -(self.completionView.frame.size.height * 0.2));
	}];

	// Tableview shenaningans
	[UIView animateWithDuration:0.3 animations:^{
		self.stepTwoTableView.alpha = 0;
	} completion:^(BOOL finished) {
		[self.stepTwoTableView reloadData];
		[UIView animateWithDuration:0.4 animations:^{
			self.stepTwoTableView.alpha = 1;
		}];
	}];
}

- (void)transitionFromSettingsToDetails // 02 -> 01
{
	[self.firstStepContainer animateReverse];

	// Scrolling + completion bar
	[UIView animateWithDuration:1 animations:^{
		self.scrollView.contentOffset = (CGPoint){0, -20};

		CGAffineTransform t = self.completionView.transform;
		self.completionView.transform = CGAffineTransformTranslate(t, 0, -(self.completionView.frame.size.height * 0.4));
		self.stepTwoTableView.transform = CGAffineTransformIdentity;
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
