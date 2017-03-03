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

@property (nonatomic) DFTFirstSectionLayout *collectionViewLayout;

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
	self.collectionViewLayout = [DFTFirstSectionLayout new];
	self.tableViewsDelegate = [DFTFormRowTableViewDelegate new];

	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];

	[self.collectionView addGestureRecognizer:pan];
	[self configureCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
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
			NSIndexPath *indexDeselect = [NSIndexPath indexPathForItem:1 inSection:0];

			if (self.currentSection == 0)
				return ;
			self.currentSection = [self previousSection];
			indexPath = [NSIndexPath indexPathForItem:self.currentSection inSection:0];
			[self.collectionView deselectItemAtIndexPath:indexDeselect animated:YES];
			[self collectionView:self.collectionView didDeselectItemAtIndexPath:indexDeselect];
		}
		else
		{
			NSIndexPath *indexDeselect = [NSIndexPath indexPathForItem:0 inSection:0];

			if (self.currentSection == 1)
				;
			self.currentSection = [self nextSection];
			indexPath = [NSIndexPath indexPathForItem:self.currentSection inSection:0];
			[self.collectionView deselectItemAtIndexPath:indexDeselect animated:YES];
			[self collectionView:self.collectionView didDeselectItemAtIndexPath:indexDeselect];
		}

		[self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
		[self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
		self.collectionViewLayout.selectedIndexPath = indexPath;
		//		[UIView animateWithDuration:0.5 animations:^{
		//			UICollectionView *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
		//
		//			CGRect rect = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height - 40);
		//			cell.frame = rect;
		//		}];
		[self.collectionView performBatchUpdates:^{
			[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
			[self.collectionView layoutIfNeeded];
		} completion:^(BOOL finished) {
			[self.collectionView setContentOffset:(CGPointMake(0, self.currentSection == 0 ? -180 : 200)) animated:YES];
		}];
	}
}

#pragma mark
#pragma mark - UICollectionView

- (void)configureCollectionView
{
	self.collectionView.collectionViewLayout = self.collectionViewLayout;
	self.collectionView.delegate = self.collectionViewLayout;
	self.collectionView.dataSource = self;
	self.collectionView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
	self.collectionView.scrollEnabled = NO;
	self.collectionView.allowsSelection = YES;

	[self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	DFTAddDropStepCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	NSInteger rowsNumber = [cell.tableView numberOfRowsInSection:0];

//	[collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	for (NSInteger i = 0; i < rowsNumber; i++)
	{
		NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];

		[cell.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
	}
//	[collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
	DFTAddDropStepCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	NSInteger rowsNumber = [cell.tableView numberOfRowsInSection:0];

//	[collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	for (NSInteger i = 0; i < rowsNumber; i++)
	{
		NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];

		[cell.tableView deselectRowAtIndexPath:index animated:YES];
	}
//	[collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

@end
