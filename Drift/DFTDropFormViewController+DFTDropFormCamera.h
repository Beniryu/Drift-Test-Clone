//
//  DFTDropFormViewController+DFTDropFormCamera.h
//  Drift
//
//  Created by Thierry Ng on 20/06/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDropFormViewController.h"


@interface DFTDropFormViewController (DFTDropFormCamera)

- (void)configureCameraActions;
- (void)configureCapture;
- (void)relaunchCaptureSession;
- (void)dismissCamera:(BOOL)removePicture;
- (void)takePicture;

@end
