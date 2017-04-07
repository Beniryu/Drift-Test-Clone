//
//  DriftViewController.h
//  Drift
//
//  Created by Thierry Ng on 26/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>
#import "DFTSegmentedControl.h"

@interface DFTDriftViewController : UIViewController <MGLMapViewDelegate, DFTSegmentedControlDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblNbDropFound;
@property (weak, nonatomic) IBOutlet UILabel *lblDropFound;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIView *segmentedContainerView;

@end
