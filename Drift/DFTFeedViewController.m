//
//  DFTFeedViewController.m
//  Drift
//
//  Created by Jonathan Nguyen on 01/03/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTFeedViewController.h"

@interface DFTFeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation DFTFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateFeedChange) name:@"DFTFeedsScaleAnimation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shrinkFeed) name:@"DFTFeedsScaleShrink" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expandFeed) name:@"DFTFeedsScaleExpand" object:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [UICollectionViewCell new];
}

#pragma mark - NSNotifications Methods

- (void)animateFeedChange
{
    if (!self.isAnimating)
    {
        self.isAnimating = YES;
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut
                         animations:
         ^{
             CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
             t = CGAffineTransformTranslate(t, 0, self.collectionView.frame.size.height * 0.05);
             
             self.collectionView.transform = t;
         } completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut
                              animations:
              ^{
                  self.collectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
              } completion:^(BOOL finished)
              {
                  self.isAnimating = !finished;
              }];
         }];
    }
}

- (void)shrinkFeed
{
    [UIView animateWithDuration:0.2 animations:
     ^{
         CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, 0.97, 0.97);
         
         t = CGAffineTransformTranslate(t, 0, self.collectionView.frame.size.height * 0.03);
         self.collectionView.transform = t;
     }];
}

- (void)expandFeed
{
    [UIView animateWithDuration:0.2 animations:
     ^{
         self.collectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
     }];
}

#pragma mark
#pragma mark - DFTFeedScreenDelegate protocol

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.delegate feedScreenDidScroll:scrollView.contentOffset.y];
}

@end
