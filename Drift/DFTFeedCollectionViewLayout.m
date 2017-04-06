//
//  DFTFeedCollectionViewLayout.m
//  Drift
//
//  Created by Thierry Ng on 26/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTFeedCollectionViewLayout.h"

@implementation DFTFeedCollectionViewLayout

static int COLLECTION_DEFAULT_INSET = 6;

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
	CGFloat width = SCREEN_SIZE.width / 2.;

	self.minimumLineSpacing = 0.;
	self.minimumInteritemSpacing = 0.;
	self.itemSize = (CGSize){width - COLLECTION_DEFAULT_INSET, 120};
	self.sectionInset = UIEdgeInsetsMake(0, COLLECTION_DEFAULT_INSET, 0, COLLECTION_DEFAULT_INSET);
}

@end
