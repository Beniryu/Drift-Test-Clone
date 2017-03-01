//
//  DFTFeedViewController.m
//  Drift
//
//  Created by Thierry Ng on 26/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTFeedViewController.h"
#import "DFTCollectionView.h"
#import "DFTFeedCollectionViewLayout.h"
#import "DFTFeedCell.h"

@interface DFTFeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTopConstraint;

@property (nonatomic) BOOL isAnimating;

@end

static const NSString *feedCellIdentifier = @"DFTFeedCell";


@implementation DFTFeedViewController

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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateFeedChange) name:@"DFTFeedsScaleAnimation" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shrinkFeed) name:@"DFTFeedsScaleShrink" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expandFeed) name:@"DFTFeedsScaleExpand" object:nil];
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

- (void)shrinkFeed
{
	[UIView animateWithDuration:0.2 animations:
	 ^{
		 CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, 0.97, 0.97);

		 t = CGAffineTransformTranslate(t, 0, self.collectionView.frame.size.height * 0.03);
		 self.collectionView.transform = t;
	 }];
}

- (void)expandFeed
{
	[UIView animateWithDuration:0.2 animations:
	 ^{
		 self.collectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
	 }];
}

- (void)animateFeedChange
{
	if (!self.isAnimating)
	{
		self.isAnimating = YES;
		[UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut
		 animations:
		 ^{
			 CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
			 t = CGAffineTransformTranslate(t, 0, self.collectionView.frame.size.height * 0.05);

			 self.collectionView.transform = t;
		 } completion:^(BOOL finished)
		 {
			 [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut
			  animations:
			  ^{
				  self.collectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
			  } completion:^(BOOL finished)
			  {
				  self.isAnimating = !finished;
			  }];
		 }];
	}
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.delegate feedScreenDidScroll:scrollView.contentOffset.y];
}

@end
