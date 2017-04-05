//
//  DFTFeedContainerViewController.m
//  Drift
//
//  Created by Thierry Ng on 10/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTFeedContainerViewController.h"
#import "DFTGlobalFeedViewController.h"
#import "DFTMapboxDelegate.h"
#import "DFTSegmentedControl.h"
#import "UIColor+DFTStyles.h"
#import "DFTScrollView.h"
#import "DFTSegmentedControl.h"
#import <Mapbox/Mapbox.h>

@interface DFTFeedContainerViewController () <UIScrollViewDelegate, DFTSegmentedControlDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mapboxView;
@property (weak, nonatomic) IBOutlet DFTScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *segmentedContainerView;


@property (weak, nonatomic) IBOutlet UIView *headerView;

// Header - Location
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currentLocationImageView;

// Header - Drops
@property (weak, nonatomic) IBOutlet UILabel *dropsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropsNumberLabel;

// Header - Drift
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UIView *driftView;
@property (weak, nonatomic) IBOutlet UILabel *driftLabel;
@property (weak, nonatomic) IBOutlet UILabel *driftLevelLabel;

@property (nonatomic) DFTFeedViewController *globalVC;
@property (nonatomic) DFTFeedViewController *innerVC;
@property (nonatomic) DFTFeedViewController *collectionVC;

@property (nonatomic) DFTMapboxDelegate *mapboxDelegate;
@property (strong, nonatomic) DFTSegmentedControl *segmentedControl;
@property (nonatomic) BOOL isManualScrolling;
@property (nonatomic) FeedType feedType;
@property (nonatomic) CGFloat currentDriftViewAlpha;

@end

static const NSString *mapStyleURL = @"mapbox://styles/d10s/cisx8as7l002g2xr0ei3xfoip";

@implementation DFTFeedContainerViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self configureMapboxView];
    [self configureCurrentLocation];
    [self configureDrops];
    [self configureDrift];
    [self configureProfilPic];
    [self configureSegmentedControl];

	self.scrollView.delegate = self;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	[self.scrollView setContentInset:UIEdgeInsetsZero];
    
    self.feedType = GlobalFeed;
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

- (void)configureCurrentLocation
{
    self.currentLocationLabel.text = @"LONDON";
    self.currentLocationImageView.image = [self.currentLocationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.currentLocationImageView setTintColor:[UIColor dft_lightRedColor]];
}

- (void)configureDrops
{
    self.dropsLabel.text = @"DROPS TODAY";
    self.dropsNumberLabel.text = @"76";
}

- (void)configureDrift
{
    self.driftLabel.text = @"Name";
    self.driftLevelLabel.text = @"Drift Level 40";
}

- (void)configureProfilPic
{
    // TODO: - Duplicate code taken from DFTFeedCell -> UIImageView category ?
    CAShapeLayer *border = [CAShapeLayer new];
    
    border.frame = self.profilePictureImageView.bounds;
    border.lineWidth = 4.;
    border.path = [UIBezierPath bezierPathWithOvalInRect:border.bounds].CGPath;
    border.strokeColor = [UIColor whiteColor].CGColor;
    border.fillColor = [UIColor clearColor].CGColor;
    [self.profilePictureImageView.layer addSublayer:border];
    self.profilePictureImageView.clipsToBounds = YES;
    self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2.;
}

- (void)configureSegmentedControl
{
    self.segmentedControl = [[[NSBundle mainBundle] loadNibNamed:@"DFTSegmentedControl" owner:self options:nil] lastObject];
    self.segmentedControl.delegate = self;
    [self.segmentedContainerView addSubview:self.segmentedControl];
}

- (void)updateFeedType:(NSInteger)index
{
    // We need to memorize alpha set to global feed in case we need to show it again
    if (self.feedType == GlobalFeed) {
        self.currentDriftViewAlpha = self.profilePictureImageView.alpha;
    }
    self.feedType = index;
    [self updateHeaderIfNeeded];
}

- (void)updateHeaderIfNeeded
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         switch (self.feedType) {
                             case GlobalFeed:
                                 self.profilePictureImageView.alpha = self.currentDriftViewAlpha;
                                 self.driftView.alpha = self.currentDriftViewAlpha;
                                 break;
                                 
                             default:
                                 self.profilePictureImageView.alpha = 0;
                                 self.driftView.alpha = 0;
                                 break;
                         }
                     }
                     completion:nil];
}

#pragma mark - DFTSegmentedControl Delegate
- (void)segmentedControlValueChanged:(NSInteger)index
{
    self.isManualScrolling = NO;

	[self resetHeaders];
    CGPoint point = (CGPoint){self.scrollView.frame.size.width * index, 0};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DFTFeedsScaleAnimation" object:self];
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self updateFeedType:index];
        [self.scrollView setContentOffset:point];
    } completion:nil];
}

#pragma mark - Feed Protocol

- (void)feedAnnotationsToMap:(id)annotations
{
	[self.mapboxView addAnnotations:annotations];
	self.mapboxView.showsUserLocation = NO;
}

- (void)feedScreenDidScroll:(CGFloat)offset
{
    if (self.feedType == GlobalFeed)
    {
        self.profilePictureImageView.alpha = (1 - (offset / self.headerView.frame.size.height));
        self.driftView.alpha = (1 - (offset / self.headerView.frame.size.height));
    }
    self.mapTopConstraint.constant = -((offset) / 7);
    self.headerTopConstraint.constant = -((offset) / 7);
}

- (void)resetHeaders
{
	self.mapTopConstraint.constant = 0;
	self.headerTopConstraint.constant = 0;

    self.profilePictureImageView.alpha = self.feedType == GlobalFeed ? 1 : 0;
	self.driftView.alpha = self.feedType == GlobalFeed ? 1 : 0;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DFTFeedsScaleShrink" object:self];
    self.isManualScrolling = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DFTFeedsScaleExpand" object:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isManualScrolling)
    {
        // Updating segmentedControl
        static NSInteger previousPage = 0;
        CGFloat pageWidth = self.scrollView.frame.size.width;
        float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        if (previousPage != page) {
            previousPage = page;
            [self.segmentedControl showSegment:page];
            [self updateFeedType:page];

			DFTFeedViewController *viewController = nil;

			if (page == 0)
			{
				viewController = self.globalVC;
				[self.mapboxView setCenterCoordinate:self.mapboxView.userLocation.location.coordinate
										   zoomLevel:1
											animated:YES];
//				self.mapboxView.showsUserLocation = NO;
//				[self.mapboxView.delegate mapView:self.mapboxView didUpdateUserLocation:self.mapboxView.userLocation];
				for (DFTDrop *annotation in self.mapboxView.annotations)
					[self.mapboxView removeAnnotation:annotation];
				[self.mapboxView addAnnotations:self.globalVC.drops];
			}
			else if (page == 1)
			{
				viewController = self.innerVC;
				[UIView animateWithDuration:2
                                      delay:1
									options: UIViewAnimationOptionCurveEaseIn
								 animations:^{
									 [self.mapboxView setCenterCoordinate:self.mapboxView.userLocation.location.coordinate
																zoomLevel:3
																 animated:YES];
								 }
					completion:nil];
				self.mapboxView.showsUserLocation = YES;
//				[self.mapboxView.delegate mapView:self.mapboxView didUpdateUserLocation:self.mapboxView.userLocation];
				for (DFTDrop *annotation in self.mapboxView.annotations)
					[self.mapboxView removeAnnotation:annotation];
				[self.mapboxView addAnnotations:self.innerVC.drops];
			}
			else if (page == 2)
				viewController = self.collectionVC;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	DFTFeedViewController *viewController = segue.destinationViewController;

	viewController.delegate = self;

	if ([segue.identifier isEqualToString:@"EmbedGlobalFeedScreen"])
		self.globalVC = viewController;
	else if ([segue.identifier isEqualToString:@"EmbedInnerFeedScreen"])
		self.innerVC = viewController;
	else if ([segue.identifier isEqualToString:@"EmbedCollectionFeedScreen"])
		self.collectionVC = viewController;
}

@end
