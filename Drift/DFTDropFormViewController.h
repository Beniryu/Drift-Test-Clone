//
//  DFTDropFormViewController.h
//  Drift
//
//  Created by Thierry Ng on 02/06/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

@import AVFoundation;

#import <UIKit/UIKit.h>

#import "DFTDropFormFirstStepView.h"

@class DFTDropFormViewController;

@protocol DFTDropFormDelegate <NSObject>

- (void)didDismissForm:(DFTDropFormViewController *)form;

@end

@interface DFTDropFormViewController : UIViewController

@property UIViewController<DFTDropFormDelegate> *delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet DFTDropFormFirstStepView *firstStepContainer;

#pragma mark
#pragma mark - Capture
@property (weak, nonatomic) IBOutlet UIButton *cameraRetryButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraValidateButton;
@property (weak, nonatomic) IBOutlet UIImageView *cameraHandle;
@property (weak, nonatomic) IBOutlet UIView *cameraButton;

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureStillImageOutput *imageOutput;
@property (nonatomic) NSData *imageData;
@property AVCaptureVideoPreviewLayer *previewLayer;

@end
