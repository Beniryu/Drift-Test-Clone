//
//  DFTInnerFeedViewController.m
//  Drift
//
//  Created by Thierry Ng on 12/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTInnerFeedViewController.h"

#import "DFTFeedCollectionViewLayout.h"
#import "DFTInnerFeedCell.h"

@interface DFTInnerFeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

//@property (weak, nonatomic) IBOutlet DFTCollectionView *collectionView;
//@property (nonatomic) BOOL isAnimating;

@end

static const NSString *innerFeedCellIdentifier = @"DFTInnerFeedCell";

@implementation DFTInnerFeedViewController

#pragma mark
#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureCollectionView];
}

#pragma mark
#pragma mark - Config

- (void)configureCollectionView
{
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	self.collectionView.showsVerticalScrollIndicator = NO;
	self.collectionView.bounces = YES;
	self.collectionView.alwaysBounceVertical = YES;

	self.collectionView.contentInset = UIEdgeInsetsMake(235., 0, 0, 0);

	UICollectionViewFlowLayout *layout = [DFTFeedCollectionViewLayout new];

	layout.itemSize = (CGSize){[[UIScreen mainScreen] bounds].size.width - 12., 156.};
	layout.minimumLineSpacing = 4.;
	self.collectionView.collectionViewLayout = layout;
}

#pragma mark
#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return (1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return (16);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	DFTInnerFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(NSString *)innerFeedCellIdentifier forIndexPath:indexPath];

	[cell configureWithItem:nil];
//	if (indexPath.item == 0)
//	{
//		CAShapeLayer *maskLayer = [CAShapeLayer new];
//
//		maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerTopLeft) cornerRadii:(CGSize){40.0, 40.0}].CGPath;
//		maskLayer.frame = cell.bounds;
//		cell.layer.mask = maskLayer;
//	}
	return (cell);
}

@end
