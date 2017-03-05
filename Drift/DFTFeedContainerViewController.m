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
@property (weak, nonatomic) IBOutlet UIView *globalFeedController;

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

@property (nonatomic) DFTMapboxDelegate *mapboxDelegate;
@property (strong, nonatomic) DFTSegmentedControl *segmentedControl;

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


#pragma mark - DFTSegmentedControl Delegate
- (void)segmentedControlValueChanged:(NSInteger)index
{
    CGPoint point = (CGPoint){self.scrollView.frame.size.width * index, 0};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"DFTFeedsScaleAnimation"
     object:self];
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.scrollView setContentOffset:point];
    } completion:nil];

}

#pragma mark - UIScrollView Delegate

- (void)feedScreenDidScroll:(CGFloat)offset
{
	self.mapTopConstraint.constant = -((offset) / 7);
	self.headerTopConstraint.constant = -((offset) / 7);
    self.profilePictureImageView.alpha = (1 - (offset / self.headerView.frame.size.height));
    self.driftView.alpha = (1 - (offset / self.headerView.frame.size.height));
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Updating segmentedControl
    static NSInteger previousPage = 0;
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        previousPage = page;
        [self.segmentedControl showSegment:page];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"EmbedGlobalFeedScreen"])
	{
		DFTGlobalFeedViewController *controller = segue.destinationViewController;
		controller.delegate = self;
	}
}

@end
