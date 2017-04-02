//
//  DFTFeedViewController.h
//  Drift
//
//  Created by Jonathan Nguyen on 01/03/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFTCollectionView.h"
#import "DFTFeedManager.h"
#import "DFTFeedContainerViewController.h"

@interface DFTFeedViewController : UIViewController

@property (nonatomic) NSArray<DFTDrop *> *drops;

@property (weak, nonatomic) IBOutlet DFTCollectionView *collectionView;
@property (nonatomic) BOOL isAnimating;
@property id<DFTFeedScreenProtocol> delegate;

- (void)becameVisibleFeed;

@end
