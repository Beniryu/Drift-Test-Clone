//
//  DFTAddDropViewController.m
//  Drift
//
//  Created by Thierry Ng on 17/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTAddDropViewController.h"
#import "DFTFirstSectionLayout.h"

#import "DFTFormRowTableViewDelegate.h"
#import "DFTAddDropStepCell.h"

@interface DFTAddDropViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) DFTFirstSectionLayout *firstSectionLayout;

@property (nonatomic) DFTFormRowTableViewDelegate *tableViewsDelegate;
@property (nonatomic) NSInteger currentSection;

@end

@implementation DFTAddDropViewController

#pragma mark
#pragma mark - UICollectionView

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.currentSection = 0;
	self.firstSectionLayout = [DFTFirstSectionLayout new];
	self.tableViewsDelegate = [DFTFormRowTableViewDelegate new];

	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];

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
	return (self.currentSection == 1 ? self.currentSection : self.currentSection + 1);
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
			indexPath = [NSIndexPath indexPathForItem:self.currentSection inSection:0];

		}
		else
		{
			self.currentSection = [self nextSection];
			indexPath = [NSIndexPath indexPathForItem:self.currentSection inSection:0];
		}
//		[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
		[self.collectionView setContentOffset:(CGPointMake(0, self.currentSection == 0 ? -180 : 300)) animated:YES];
	}
}

#pragma mark
#pragma mark - UICollectionView

- (void)configureCollectionView
{
	self.collectionView.collectionViewLayout = self.firstSectionLayout;
	self.collectionView.delegate = self.firstSectionLayout;
	self.collectionView.dataSource = self;
//	self.collectionView.contentOffset = CGPointMake(0, 140);
	self.collectionView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
	self.collectionView.scrollEnabled = NO;
}

#pragma mark
#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return (2);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	DFTAddDropStepCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddDropStepCell" forIndexPath:indexPath];

	cell.tableView.delegate = self.tableViewsDelegate;
	cell.tableView.dataSource = self.tableViewsDelegate;

	if (indexPath.section == 0)
		cell.backgroundColor = [UIColor redColor];
	if (indexPath.section == 1)
		cell.backgroundColor = [UIColor cyanColor];
	if (indexPath.section == 2)
			cell.backgroundColor = [UIColor greenColor];
	return (cell);
}

@end
