//
//  DFTFeedViewController.h
//  Drift
//
//  Created by Thierry Ng on 26/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFTFeedContainerViewController.h"
#import "DFTFeedViewController.h"

@interface DFTGlobalFeedViewController : DFTFeedViewController

@property id<DFTFeedScreenProtocol> delegate;

@end
