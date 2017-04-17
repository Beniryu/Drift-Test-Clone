//
//  DFTDropViewController.m
//  Drift
//
//  Created by Thierry Ng on 19/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

@import AVFoundation;

#import "DFTDropViewController.h"

#import "DFTAddDropViewController.h"

#import "DFTRadialGradientLayer.h"
#import "DFTJellyTrigger.h"
#import "VLDContextSheet.h"
#import "VLDContextSheetItem.h"

#import "DFTMapboxDelegate.h"
#import <Mapbox/Mapbox.h>
#import <lottie-ios/Lottie/Lottie.h>

@interface DFTDropViewController () <VLDContextSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *veilImageView;
@property (weak, nonatomic) IBOutlet DFTJellyTrigger *jellyTrigger;

@property (nonatomic) VLDContextSheet *contextSheet;
@property (nonatomic) DFTMapboxDelegate *mapDelegate;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

#pragma mark
#pragma mark - Capture
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureStillImageOutput *imageOutput;

@end

//static const NSString *mapStyleURL = @"mapbox://styles/d10s/cisx8as7l002g2xr0ei3xfoip";

@implementation DFTDropViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.veilImageView.userInteractionEnabled = NO;
	self.veilImageView.hidden = YES;
	[self configureJelly];
//	[self configureCapture];
//
//	CGPoint point = (CGPoint){CGRectGetMidX(self.view.bounds), self.view.bounds.size.height / 3};
//	DFTRadialGradientLayer *gradientLayer = [[DFTRadialGradientLayer alloc] initWithCenterPoint:point];
//
//	gradientLayer.frame = self.view.bounds;
//	[self.view.layer addSublayer:gradientLayer];
//
//	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveToRoll)];
//	[self.view addGestureRecognizer:tap];
//	[self.view bringSubviewToFront:self.tempLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
//	LOTAnimationView *animation = [LOTAnimationView animationNamed:@"square"];
//	[self.view addSubview:animation];
//	[animation playWithCompletion:nil];
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self contextSheet:nil didSelectItem:nil];
//}

#pragma mark
#pragma mark - AVCapture
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
	[self.view.layer addSublayer:previewLayer];

	[self.captureSession startRunning];
}

- (void)saveToRoll
{
	AVCaptureConnection *connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];

	if (connection != nil)
	{
		[self.imageOutput captureStillImageAsynchronouslyFromConnection:connection
													  completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
		 {
			 if (error == nil)
			 {
				 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];

				 UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:imageData], nil, nil, nil);
				 [self.captureSession stopRunning];
			 }
		 }];
	}
}

#pragma mark
#pragma mark - VLDContextSheet

- (void)configureJelly
{
	UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self
																									action: @selector(engageJelly:)];
	gestureRecognizer.minimumPressDuration = 0.01;
	[self.view addGestureRecognizer: gestureRecognizer];

    //TODO: localization
	VLDContextSheetItem *item1 = [[VLDContextSheetItem alloc] initWithTitle: NSLocalizedString(@"Gift", nil)
																	  image: [UIImage imageNamed: @"picto_location"]
														   highlightedImage: [UIImage imageNamed: @"picto_location"]];

	VLDContextSheetItem *item2 = [[VLDContextSheetItem alloc] initWithTitle: NSLocalizedString(@"Add to", nil)
																	  image: [UIImage imageNamed: @"picto_location"]
														   highlightedImage: [UIImage imageNamed: @"picto_location"]];

	VLDContextSheetItem *item3 = [[VLDContextSheetItem alloc] initWithTitle: NSLocalizedString(@"share", nil)
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
//	NSLog(@"Selected : %@", item.title);

	DFTAddDropViewController *addDropVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([DFTAddDropViewController class])];

	addDropVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
	[self presentViewController:addDropVC animated:NO completion:nil];
}

@end
