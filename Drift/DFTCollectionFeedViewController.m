//
//  DFTCollectionFeedViewController.m
//  Drift
//
//  Created by Thierry Ng on 12/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTCollectionFeedViewController.h"
#import "DFTCollectionFeedCell.h"
#import "DFTFeedCollectionViewLayout.h"

@interface DFTCollectionFeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

static const NSString *collectionFeedCellIdentifier = @"DFTCollectionFeedCell";
static const double sizeReduce = 18.;
static const double cellHeight = 156.;

@implementation DFTCollectionFeedViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self configureCollectionView];
}

- (void)configureCollectionView
{
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	self.collectionView.showsVerticalScrollIndicator = NO;
	self.collectionView.bounces = YES;
	self.collectionView.alwaysBounceVertical = YES;

	UICollectionViewFlowLayout *layout = [DFTFeedCollectionViewLayout new];

	layout.itemSize = (CGSize){SCREEN_SIZE.width - sizeReduce, cellHeight};
	layout.minimumLineSpacing = 3.;
	layout.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 235.);
	self.collectionView.collectionViewLayout = layout;
}

- (void)expandCollectionView
{
	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
	layout.itemSize = (CGSize){SCREEN_SIZE.width, layout.itemSize.height};
}

- (void)shrinkCollectionView
{
	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
	layout.itemSize = (CGSize){SCREEN_SIZE.width - sizeReduce, layout.itemSize.height};
}

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
	DFTCollectionFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(NSString *)collectionFeedCellIdentifier forIndexPath:indexPath];
//	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(NSString *)collectionFeedCellIdentifier forIndexPath:indexPath];
//	[cell configureWithItem:nil];
	return (cell);
}


@end
