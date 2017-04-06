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
#import "DFTDrop.h"

@interface DFTInnerFeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) NSArray<DFTDrop *> *drops;

@end

static const NSString *innerFeedCellIdentifier = @"DFTInnerFeedCell";
static const double sizeReduce = 12.;
static const double cellHeight = 156.;

@implementation DFTInnerFeedViewController

#pragma mark
#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureCollectionView];
	DFTFeedManager *manager = [DFTFeedManager new];

	[manager buildFeedWithCompletion:^(id  _Nullable responseObject, NSError * _Nullable error)
	 {
		 self.drops = responseObject;
		 [self.collectionView reloadData];
	 }];
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

	UICollectionViewFlowLayout *layout = [DFTFeedCollectionViewLayout new];

	layout.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 255.f);
	layout.itemSize = (CGSize){SCREEN_SIZE.width - sizeReduce, cellHeight};
	layout.minimumLineSpacing = 4.;

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

#pragma mark
#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return (1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return (self.drops.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	DFTInnerFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(NSString *)innerFeedCellIdentifier forIndexPath:indexPath];

	[cell configureWithItem:self.drops[indexPath.row]];

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
