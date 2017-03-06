//
//  DFTDropViewController.m
//  Drift
//
//  Created by Thierry Ng on 19/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDropViewController.h"

#import "DFTAddDropViewController.h"

#import "DFTJellyTrigger.h"
#import "VLDContextSheet.h"
#import "VLDContextSheetItem.h"

#import "DFTMapboxDelegate.h"
#import <Mapbox/Mapbox.h>

@interface DFTDropViewController () <VLDContextSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *veilImageView;
@property (weak, nonatomic) IBOutlet DFTJellyTrigger *jellyTrigger;

@property (nonatomic) VLDContextSheet *contextSheet;
@property (nonatomic) DFTMapboxDelegate *mapDelegate;

@end

//static const NSString *mapStyleURL = @"mapbox://styles/d10s/cisx8as7l002g2xr0ei3xfoip";

@implementation DFTDropViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.veilImageView.userInteractionEnabled = NO;
	[self configureJelly];
}

- (void)configureJelly
{
	UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self
																									action: @selector(engageJelly:)];
	gestureRecognizer.minimumPressDuration = 0.01;
	[self.view addGestureRecognizer: gestureRecognizer];

	VLDContextSheetItem *item1 = [[VLDContextSheetItem alloc] initWithTitle: @"Gift"
																	  image: [UIImage imageNamed: @"picto_location"]
														   highlightedImage: [UIImage imageNamed: @"picto_location"]];

	VLDContextSheetItem *item2 = [[VLDContextSheetItem alloc] initWithTitle: @"Add to"
																	  image: [UIImage imageNamed: @"picto_location"]
														   highlightedImage: [UIImage imageNamed: @"picto_location"]];

	VLDContextSheetItem *item3 = [[VLDContextSheetItem alloc] initWithTitle: @"Share"
																	  image: [UIImage imageNamed: @"picto_location"]
														   highlightedImage: [UIImage imageNamed: @"picto_location"]];

	self.contextSheet = [[VLDContextSheet alloc] initWithItems: @[item1, item2, item3]];
	self.contextSheet.delegate = self;
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
	NSLog(@"Selected : %@", item.title);

	DFTAddDropViewController *addDropVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([DFTAddDropViewController class])];

	addDropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
	[self presentViewController:addDropVC animated:NO completion:nil];
}

@end
