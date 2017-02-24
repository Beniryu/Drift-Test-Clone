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

@property (nonatomic) NSInteger currentSection;

@end

@implementation DFTAddDropViewController

#pragma mark
#pragma mark - UICollectionView

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.firstSectionLayout = [DFTFirstSectionLayout new];

	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];

	self.currentSection = 0;
	[self.collectionView addGestureRecognizer:pan];
	[self configureCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

}

- (NSInteger)previousSection
{
	return (self.currentSection == 0 ? self.currentSection : self.currentSection - 1);
}

- (NSInteger)nextSection
{
	return (self.currentSection == 2 ? self.currentSection : self.currentSection + 1);
}

- (void)didPan:(UIPanGestureRecognizer *)sender
{
	if (sender.state == UIGestureRecognizerStateEnded)
	{
		CGPoint velocity = [sender velocityInView:self.collectionView];
		NSIndexPath *indexPath = nil;

		if (velocity.y > 0)
		{
			self.currentSection = [self previousSection];
			indexPath = [NSIndexPath indexPathForItem:0 inSection:self.currentSection];

		}
		else
		{
			self.currentSection = [self nextSection];
			indexPath = [NSIndexPath indexPathForItem:0 inSection:self.currentSection];
		}
		[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
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
	return (4);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Test" forIndexPath:indexPath];

	if (indexPath.section == 0)
		cell.backgroundColor = [UIColor redColor];
	if (indexPath.section == 1)
		cell.backgroundColor = [UIColor cyanColor];
	if (indexPath.section == 2)
			cell.backgroundColor = [UIColor greenColor];
	return (cell);
}

@end
