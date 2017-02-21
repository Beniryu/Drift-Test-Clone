//
//  DFTFirstSectionLayout.m
//  Drift
//
//  Created by Thierry Ng on 21/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTFirstSectionLayout.h"

@interface DFTFirstSectionLayout ()

@property (nonatomic) CGFloat screenWidth;

@end

@implementation DFTFirstSectionLayout

- (instancetype)init
{
	if (self = [super init])
		[self setup];
	return (self);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
		[self setup];
	return (self);
}

- (void)setup
{
	self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
	self.minimumInteritemSpacing = 0.;
	self.minimumLineSpacing = 0.;
	self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
	return ((CGSize){self.screenWidth, 80});
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return ((CGSize){self.screenWidth, 60});
}

@end
