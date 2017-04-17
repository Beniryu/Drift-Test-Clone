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
	self.screenWidth = SCREEN_SIZE.width;
//	self.minimumInteritemSpacing = 0.;
	self.minimumLineSpacing = 80.;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 0;

	if (indexPath.item == 0)
	{
		height = ([indexPath isEqual:self.selectedIndexPath] ? 250 : 180);
	}
	if (indexPath.item == 1)
	{
		height = ([indexPath isEqual:self.selectedIndexPath] ? 200 : 140);
	}
	return ((CGSize){self.screenWidth, height});
}


@end
