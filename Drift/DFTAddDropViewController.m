//
//  DFTAddDropViewController.m
//  Drift
//
//  Created by Thierry Ng on 17/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTAddDropViewController.h"
#import "DFTFirstSectionLayout.h"

@interface DFTAddDropViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) DFTFirstSectionLayout *firstSectionLayout;

@end

@implementation DFTAddDropViewController

#pragma mark
#pragma mark - UICollectionView

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.firstSectionLayout = [DFTFirstSectionLayout new];

	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];

	[self.collectionView addGestureRecognizer:pan];
	[self configureCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

}

- (void)didPan:(UIPanGestureRecognizer *)sender
{
	if (sender.state == UIGestureRecognizerStateEnded)
	{
		CGPoint velocity = [sender velocityInView:self.collectionView];

		if (velocity.y > 0)
		{
			NSLog (@"Pan down Go up");
		}
		else
		{
			NSLog (@"Pan Up Go down");
		}
	}
}

#pragma mark
#pragma mark - UICollectionView

- (void)configureCollectionView
{
	self.collectionView.collectionViewLayout = self.firstSectionLayout;
	self.collectionView.delegate = self.firstSectionLayout;
	self.collectionView.dataSource = self;

	self.collectionView.scrollEnabled = NO;
}

#pragma mark
#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return (3);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return (10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Test" forIndexPath:indexPath];

	cell.backgroundColor = [UIColor redColor];
	return (cell);
}

@end
