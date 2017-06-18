//
//  DFTDropViewController.m
//  Drift
//
//  Created by Thierry Ng on 19/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDropViewController.h"

#import "DFTAddDropViewController.h"
#import "ImageUtils.h"
#import "UIColor+DFTStyles.h"

#import "DFTSegmentedControl.h"
#import "DFTRadialGradientLayer.h"
#import "DFTJellyTrigger.h"
#import "VLDContextSheet.h"
#import "VLDContextSheetItem.h"

#import "DFTMapboxDelegate.h"
#import <Mapbox/Mapbox.h>
#import "DFTMapManager.h"

#import <lottie-ios/Lottie/Lottie.h>

@interface DFTDropViewController () <VLDContextSheetDelegate, DFTSegmentedControlDelegate>
{
@private
MGLMapView *mapViewShared;
}
@property (weak, nonatomic) IBOutlet UIImageView *veilImageView;
@property (weak, nonatomic) IBOutlet DFTJellyTrigger *jellyTrigger;

@property (nonatomic) VLDContextSheet *contextSheet;
@property (nonatomic) DFTMapboxDelegate *mapDelegate;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (strong, nonatomic) DFTSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *segmentedContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

//static const NSString *mapStyleURL = @"mapbox://styles/d10s/cisx8as7l002g2xr0ei3xfoip";

@implementation DFTDropViewController

@synthesize imgLocation, btnBulle, lblLocation, lblCurrentPosition;

- (void)viewDidLoad 
{
    [super viewDidLoad];

	self.veilImageView.userInteractionEnabled = NO;
	[self configureJelly];
    [self configureSegmentedControl];
    [self configureLocation];

//
//	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveToRoll)];
//	[self.view addGestureRecognizer:tap];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//	LOTAnimationView *animation = [LOTAnimationView animationNamed:@"square"];
//	[self.view addSubview:animation];
//	[animation playWithCompletion:nil];

    [self configureMap];
	[self.view bringSubviewToFront:self.veilImageView];
}

#pragma mark - Configuration

-(void) configureLocation
{
    [imgLocation setTintColor:[UIColor dft_salmonColor]];
//    lblCurrentPosition.text = NSLocalizedString(@"currentPosition", nil);
//    lblLocation.text = @"Bastille, Paris";
}

- (void)configureSegmentedControl
{
    self.segmentedControl = [[[NSBundle mainBundle] loadNibNamed:@"DFTSegmentedControl" owner:self options:nil] lastObject];
    [self.segmentedControl configForDrop];
    self.segmentedControl.delegate = self;
    [self.segmentedContainerView addSubview:self.segmentedControl];
}

- (void)configureMap
{
    [[DFTMapManager sharedInstance] removeAllDropsToMap];
	[[DFTMapManager sharedInstance] addMapToView:self.view withDelegate:self];

//	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_mask"]];

    mapViewShared = [DFTMapManager sharedInstance].mapView;
//	imageView.frame = mapViewShared.frame;
//	imageView.contentMode = UIViewContentModeScaleAspectFit;
//	[mapViewShared addSubview:imageView];
}

#pragma mark - DFTSegmentedControl Delegate
- (void)segmentedControlValueChanged:(NSInteger)index
{
    //TODO: faire le changement
}

#pragma mark - Map delegate
- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView
{
    [[DFTMapManager sharedInstance] setCenterCoordinateWithZoom:15];
}

#pragma mark
#pragma mark - VLDContextSheet

- (void)configureJelly
{
//	UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self
//																									action: @selector(engageJelly:)];
//	gestureRecognizer.minimumPressDuration = 0.01;
//	[self.jellyTrigger addGestureRecognizer: gestureRecognizer];
//
//    //TODO: localization
//	VLDContextSheetItem *item1 = [[VLDContextSheetItem alloc] initWithTitle: NSLocalizedString(@"Gift", nil)
//																	  image: [UIImage imageNamed: @"picto_location"]
//														   highlightedImage: [UIImage imageNamed: @"picto_location"]];
//
//	VLDContextSheetItem *item2 = [[VLDContextSheetItem alloc] initWithTitle: NSLocalizedString(@"Add to", nil)
//																	  image: [UIImage imageNamed: @"picto_location"]
//														   highlightedImage: [UIImage imageNamed: @"picto_location"]];
//
//	VLDContextSheetItem *item3 = [[VLDContextSheetItem alloc] initWithTitle: NSLocalizedString(@"share", nil)
//																	  image: [UIImage imageNamed: @"picto_location"]
//														   highlightedImage: [UIImage imageNamed: @"picto_location"]];
//
//	self.contextSheet = [[VLDContextSheet alloc] initWithItems: @[item1, item2, item3]];
//	self.contextSheet.delegate = self;
    
    
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(creationDrop:)];
	[self.jellyTrigger addGestureRecognizer: gestureRecognizer];
    [ImageUtils roundedBorderImageView:self.jellyTrigger lineWidth:0.];
}

- (void)engageJelly:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
	{
		[self.contextSheet startWithGestureRecognizer:gestureRecognizer inView:self.view withAnchor:self.jellyTrigger.center];
	}
}

- (void)contextSheet:(VLDContextSheet *)contextSheet didSelectItem:(VLDContextSheetItem *)item
{
//	NSLog(@"Selected : %@", item.title);

//	DFTAddDropViewController *addDropVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([DFTAddDropViewController class])];

	UINavigationController *addDropVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationControllerWithAddDrop"];

	CGPoint point = (CGPoint){CGRectGetMidX(self.view.bounds), self.view.bounds.size.height / 3};
	DFTRadialGradientLayer *gradientLayer = [[DFTRadialGradientLayer alloc] initWithCenterPoint:point andColors:@[@0, @0, @0, @0, @0.3, @0.3, @1, @0.9]];

	gradientLayer.frame = self.view.bounds;
	[addDropVC.view.layer insertSublayer:gradientLayer atIndex:0];
	addDropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
	addDropVC.navigationBarHidden = YES;

	self.tabBarController.tabBar.hidden = YES;
	self.bottomConstraint.constant = -50.;

	[self.jellyTrigger setHidden:YES];

	[self presentViewController:addDropVC animated:NO completion:nil];
}

-(void)creationDrop:(UIGestureRecognizer *)gestureRecognizer
{
    [self contextSheet:nil didSelectItem:nil];
}

@end
