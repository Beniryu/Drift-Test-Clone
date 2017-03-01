//
//  DFTFeedViewController.m
//  Drift
//
//  Created by Thierry Ng on 26/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTGlobalFeedViewController.h"
#import "DFTCollectionView.h"
#import "DFTFeedCollectionViewLayout.h"
#import "DFTFeedCell.h"

@interface DFTGlobalFeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTopConstraint;

@end

static const NSString *feedCellIdentifier = @"DFTFeedCell";


@implementation DFTGlobalFeedViewController

#pragma mark
#pragma mark - Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];

	//NSLog (@"Font families: %@", [UIFont familyNames]);
	//self.collectionTopConstraint.constant = self.view.frame.size.height;
//	[CATransaction begin];
//	[CATransaction setDisableActions:YES];
//	self.collectionView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.collectionView.frame.size.height);
//	[CATransaction commit];

	[self configureCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
	//	self.collectionTopConstraint.constant = -20;
	//	[UIView animateWithDuration:.75f animations:
	//	 ^{
	//		 self.collectionView.hidden = NO;
	//		 [self.view layoutIfNeeded];
	//		 [self.collectionView layoutIf

//	[UIView animateWithDuration:0.5 animations:^{
//		self.collectionView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.collectionView.frame.size.height);
//	}];
}

#pragma mark
#pragma mark - Config

- (void)configureCollectionView
{
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	self.collectionView.showsVerticalScrollIndicator = NO;

	UICollectionViewFlowLayout *layout = [DFTFeedCollectionViewLayout new];

	layout.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 235.f);
	self.collectionView.collectionViewLayout = layout;
	[self.collectionView registerNib:[UINib nibWithNibName:(NSString *)feedCellIdentifier bundle:nil] forCellWithReuseIdentifier:(NSString *)feedCellIdentifier];
}


#pragma mark
#pragma mark - UICollectionView protocols

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
	DFTFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(NSString *)feedCellIdentifier forIndexPath:indexPath];

	[cell configureWithDrop:nil];
	return (cell);
}

#pragma mark
#pragma mark - DFTFeedScreenDelegate protocol

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.delegate feedScreenDidScroll:scrollView.contentOffset.y];
}

@end
