//
//  DFTFeedContainerViewController.m
//  Drift
//
//  Created by Thierry Ng on 10/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTFeedContainerViewController.h"
#import "DFTFeedViewController.h"
#import "DFTMapboxDelegate.h"
#import "UIColor+DFTStyles.h"
#import "DFTScrollView.h"
#import <Mapbox/Mapbox.h>

@interface DFTFeedContainerViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapboxView;
@property (weak, nonatomic) IBOutlet DFTScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopConstraint;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIView *globalFeedController;



@property (nonatomic) DFTMapboxDelegate *mapboxDelegate;
@property (nonatomic) NSUInteger currentPage;

@end

static const NSString *mapStyleURL = @"mapbox://styles/d10s/cisx8as7l002g2xr0ei3xfoip";

@implementation DFTFeedContainerViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self configureMapboxView];

	self.currentPage = 0;

	self.segmentedControl.backgroundColor = [UIColor dft_salmonColor];
	self.segmentedControl.tintColor = [UIColor clearColor];
	self.segmentedControl.layer.cornerRadius = self.segmentedControl.frame.size.height / 2.;

	self.scrollView.delegate = self;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	[self.scrollView setContentInset:UIEdgeInsetsZero];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];

	self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);
}

- (void)configureMapboxView
{
	self.mapboxDelegate = [DFTMapboxDelegate new];
	self.mapboxView.styleURL = [NSURL URLWithString:(NSString *)mapStyleURL];
	self.mapboxView.showsUserLocation = YES;
	self.mapboxView.zoomEnabled = NO;
	self.mapboxView.scrollEnabled = NO;
	self.mapboxView.zoomLevel = 1;
	self.mapboxView.delegate = self.mapboxDelegate;
}

- (IBAction)segmentChangedValue
{
	self.currentPage = self.segmentedControl.selectedSegmentIndex;
	CGPoint point = (CGPoint){self.scrollView.frame.size.width * self.segmentedControl.selectedSegmentIndex, 0};
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:@"DFTFeedsScaleAnimation"
	 object:self];
	[UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[self.scrollView setContentOffset:point];
	} completion:nil];
}

- (void)feedScreenDidScroll:(CGFloat)offset
{
	self.mapTopConstraint.constant = -((260 + offset) / 7);
	self.headerTopConstraint.constant = -((260 + offset) / 7);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DFTFeedsScaleShrink" object:self];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:@"DFTFeedsScaleExpand"
	 object:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"EmbedGlobalFeedScreen"])
	{
		DFTFeedViewController *controller = segue.destinationViewController;

		controller.delegate = self;
	}
}

@end
