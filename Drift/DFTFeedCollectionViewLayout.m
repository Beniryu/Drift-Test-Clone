//
//  DFTFeedCollectionViewLayout.m
//  Drift
//
//  Created by Thierry Ng on 26/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTFeedCollectionViewLayout.h"

@implementation DFTFeedCollectionViewLayout

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
	CGFloat width = [[UIScreen mainScreen] bounds].size.width / 2.;

	self.itemSize = (CGSize){width - 6, 120};
	self.minimumInteritemSpacing = 0.;
	self.minimumLineSpacing = 0.;
	self.sectionInset = UIEdgeInsetsMake(0, 6, 0, 6);
}

@end
