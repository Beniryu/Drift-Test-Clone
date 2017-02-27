//
//  DriftViewController.m
//  Drift
//
//  Created by Thierry Ng on 26/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDriftViewController.h"

@interface DFTDriftViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DFTDriftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self configureCollectionView];
}

- (void)configureCollectionView
{
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;

	UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];

	layout.itemSize = (CGSize){self.collectionView.frame.size.width - 32, 167};
	layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
	layout.minimumLineSpacing = 16.;
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

	self.collectionView.collectionViewLayout = layout;
	self.collectionView.showsHorizontalScrollIndicator = NO;
	self.collectionView.pagingEnabled = YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return (1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return (5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Test" forIndexPath:indexPath];

	return (cell);
}

@end
