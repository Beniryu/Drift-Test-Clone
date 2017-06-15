//
//  DFTDropSignalViewController.m
//  Drift
//
//  Created by Thierry Ng on 16/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDropSignalViewController.h"

@interface DFTDropSignalViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

#pragma mark screens
@property (weak, nonatomic) IBOutlet UICollectionView *recentCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *groupCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *nearbyCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *allTableView;

@end

@implementation DFTDropSignalViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self configureScrollView];
	[self configureRecentScreen];
	[self configureGroupScreen];
	[self configureNearbyScreen];
	[self configureAllScreen];
}

#pragma mark
#pragma mark - Config

- (void)configureScrollView
{
	self.scrollView.delegate = self;
	self.scrollView.bounces = NO;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)configureSegmentedControl
{

}

- (void)configureRecentScreen
{
	self.recentCollectionView.delegate = self;
	self.recentCollectionView.dataSource = self;
}

- (void)configureGroupScreen
{
	self.groupCollectionView.delegate = self;
	self.groupCollectionView.dataSource = self;
}

- (void)configureNearbyScreen
{
	self.nearbyCollectionView.delegate = self;
	self.nearbyCollectionView.dataSource = self;
}

- (void)configureAllScreen
{
	self.allTableView.delegate = self;
	self.allTableView.dataSource = self;

	self.allTableView.allowsMultipleSelection = YES;
	self.allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (IBAction)dismissScreen:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
#pragma mark - Screen Flow

- (IBAction)didChangeSegment:(id)sender
{
	CGRect rect;

	if (self.segmentedControl.selectedSegmentIndex == 0)
		rect = self.recentCollectionView.superview.frame;
	else if (self.segmentedControl.selectedSegmentIndex == 1)
		rect = self.groupCollectionView.superview.frame;
	else if (self.segmentedControl.selectedSegmentIndex == 2)
		rect = self.nearbyCollectionView.superview.frame;
	else
		rect = self.allTableView.superview.frame;
	[self.scrollView scrollRectToVisible:rect animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView == self.scrollView)
	{
		CGFloat offsetX = self.scrollView.contentOffset.x;

		if (offsetX == 0)
			self.segmentedControl.selectedSegmentIndex = 0;
		else if (offsetX == self.scrollView.frame.size.width)
			self.segmentedControl.selectedSegmentIndex = 1;
		else if (offsetX == self.scrollView.frame.size.width * 2)
			self.segmentedControl.selectedSegmentIndex = 2;
		else if (offsetX == self.scrollView.frame.size.width * 3)
			self.segmentedControl.selectedSegmentIndex = 3;
	}
}

#pragma mark
#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return (1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (collectionView == self.recentCollectionView)
	{
		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

		return (cell);
	}
	else if (collectionView == self.groupCollectionView)
	{
		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

		return (cell);
	}
	else // self.nearbyCollectionView
	{
		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

		return (cell);
	}
}

#pragma mark
#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return (55.);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (1);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	UIView *view = [UIView new];

	view.frame = CGRectMake(0., 0., 30., 30.);
	view.backgroundColor = [UIColor redColor];
	view.layer.cornerRadius = 15.;
	view.clipsToBounds = YES;
	cell.accessoryView = view;
	cell.imageView.image = [UIImage imageNamed:@"feed_cell_profile_pic_placeholder"];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.text = @"Name of contact";
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return (cell);
}

@end

@import AVFoundation;

#import "DFTDropFormManager.h"
#import "DFTDropFormViewController.h"

#import "DFTDropFormFirstStepView.h"

#import "DFTOptionTableViewCell.h"
#import "DFTDropSignalViewController.h"


@interface DFTTagManagement : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *completionView;
@property (weak, nonatomic) IBOutlet UIImageView *cameraHandle;

@property (weak, nonatomic) IBOutlet DFTDropFormFirstStepView *firstStepContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstStepHeight;
@property (weak, nonatomic) IBOutlet UITableView *stepTwoTableView;

@property (nonatomic) DFTDropFormManager *manager;
@property (nonatomic) NSInteger currentSection;
@property (nonatomic) BOOL firstAppearance;

#pragma mark
#pragma mark - Capture
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureStillImageOutput *imageOutput;

@end

@implementation DFTTagManagement

- (instancetype)init
{
	if (self = [super init])
		[self commonInit];
	return (self);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
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
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self configureCapture];
	if (self.firstAppearance)
	{
		[UIView animateWithDuration:1 animations:^{
			self.completionView.transform = CGAffineTransformMakeTranslation(0, -(self.completionView.frame.size.height * 0.6));
		}];
		[self.firstStepContainer appear];
		self.firstAppearance = NO;
	}
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return (YES);
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
		self.scrollView.contentOffset = (CGPoint){0, 0};

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

- (void)launchCamera:(UIPanGestureRecognizer *)sender
{
	CGPoint point = [sender locationInView:self.view];

	//	NSLog(@"Point : %f", point.y);
	if (point.y >= 170.0)
	{
		[self configureCapture];
	}
}

- (void)configureCapture
{
	// Setting Session
	self.captureSession = [AVCaptureSession new];
	self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;

	// Setting Device + Input
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];

	if (input != nil && [self.captureSession canAddInput:input])
		[self.captureSession addInput:input];

	// Setting Output
	self.imageOutput = [AVCaptureStillImageOutput new];
	self.imageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
	if ([self.captureSession canAddOutput:self.imageOutput])
		[self.captureSession addOutput:self.imageOutput];
	// Preview
	AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];

	previewLayer.frame = self.view.bounds;
	previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[self.view.layer insertSublayer:previewLayer below:self.scrollView.layer];

	[self.captureSession startRunning];
}


@end
