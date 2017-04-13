//
//  DFTProfileMostLikedView.m
//  Drift
//
//  Created by Thierry Ng on 12/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTProfileMostLikedView.h"

@interface DFTProfileMostLikedView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DFTProfileMostLikedView

- (UIView *)loadViewFromNib
{
	NSString *nibName = NSStringFromClass([DFTProfileMostLikedView class]);

	return ([[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] firstObject]);
}

- (void)awakeFromNib
{
	[super awakeFromNib];

	[self configureTitle];
	[self configureCollectionView];
}

- (void)configureTitle
{
	self.titleLabel.text = @"Title";
}

- (void)configureCollectionView
{
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.collectionView registerNib:[] forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark
#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return (5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

	return (cell);
}

@end
