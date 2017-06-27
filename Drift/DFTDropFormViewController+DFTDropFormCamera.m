//
//  DFTDropFormViewController+DFTDropFormCamera.m
//  Drift
//
//  Created by Thierry Ng on 20/06/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

@import AVFoundation;
#import "DFTDropFormViewController+DFTDropFormCamera.h"

@implementation DFTDropFormViewController (DFTDropFormCamera)

- (void)configureCameraActions
{
	self.cameraRetryButton.alpha = 0;
	self.cameraValidateButton.alpha = 0;

	[self.cameraRetryButton addTarget:self action:@selector(relaunchCaptureSession) forControlEvents:UIControlEventTouchUpInside];
	[self.cameraValidateButton addTarget:self action:@selector(dismissCamera:) forControlEvents:UIControlEventTouchUpInside];
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
	self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
	CGRect previewFrame = self.view.bounds;

	previewFrame.origin.y = -self.view.frame.size.height;
	self.previewLayer.frame = previewFrame;
	self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[self.view.layer insertSublayer:self.previewLayer below:self.scrollView.layer];

	[self.captureSession startRunning];

	[UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionTransitionNone animations:^{
		self.previewLayer.transform = CATransform3DMakeTranslation(0, self.view.frame.size.height, 0);
	} completion:nil];
}

- (void)relaunchCaptureSession
{
	[self.captureSession startRunning];

	[UIView animateWithDuration:0.4 animations:^{
		self.cameraValidateButton.alpha = 0;
		self.cameraRetryButton.alpha = 0;
		self.cameraValidateButton.hidden = YES;
		self.cameraRetryButton.hidden = YES;
	}];
}

- (void)dismissCamera:(BOOL)removePicture
{
	[self.firstStepContainer arrangeForCameraDismissal];
	[self.captureSession stopRunning];
	if (removePicture)
		[self.previewLayer removeFromSuperlayer];
	[UIView animateWithDuration:0.4 animations:^{
		self.cameraRetryButton.alpha = 0;
		self.cameraValidateButton.alpha = 0;
		self.cameraButton.alpha = 0;
		self.cameraHandle.alpha = 1;
		self.scrollView.contentOffset = (CGPoint){0, -20};
	} completion:^(BOOL finished) {

		self.cameraValidateButton.hidden = YES;
		self.cameraRetryButton.hidden = YES;
		self.cameraButton.hidden = YES;
	}];
}

- (void)takePicture
{
	AVCaptureConnection *connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];

	self.cameraRetryButton.hidden = NO;
	self.cameraValidateButton.hidden = NO;

	[UIView animateWithDuration:0.4 animations:^{
		self.cameraRetryButton.alpha = 1;
		self.cameraValidateButton.alpha = 1;
	}];

	if (connection != nil)
	{
		[self.captureSession stopRunning];
		[self.imageOutput captureStillImageAsynchronouslyFromConnection:connection
													  completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
		 {
			 if (error == nil)
			 {
				 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];

				 UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:imageData], nil, nil, nil);
			 }
		 }];
	}
}

@end
