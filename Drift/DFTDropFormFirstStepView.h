//
//  DFTDropFormFirstStepView.h
//  Drift
//
//  Created by Thierry Ng on 02/06/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DFTDrop;

@interface DFTDropFormFirstStepView : UIView

- (void)appear;
- (void)animateForward;
- (void)animateReverse;
- (void)arrangeForCamera;
- (void)arrangeForCameraDismissal;
- (void)fillDrop:(DFTDrop *)drop;

@end
