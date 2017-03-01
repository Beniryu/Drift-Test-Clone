//
//  DFTFeedViewController.h
//  Drift
//
//  Created by Jonathan Nguyen on 01/03/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFTCollectionView.h"

@interface DFTFeedViewController : UIViewController

@property (weak, nonatomic) IBOutlet DFTCollectionView *collectionView;
@property (nonatomic) BOOL isAnimating;

@end
