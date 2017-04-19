//
//  DFTDropSignalViewController.m
//  Drift
//
//  Created by Thierry Ng on 16/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDropSignalViewController.h"

@interface DFTDropSignalViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

#pragma mark screens
@property (weak, nonatomic) IBOutlet UICollectionView *recentCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *groupCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *nearbyCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *allTableView;

@end

@implementation DFTDropSignalViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self configureScrollView];
	[self configureRecentScreen];
	[self configureGroupScreen];
	[self configureNearbyScreen];
	[self configureAllScreen];
}

#pragma mark
#pragma mark - Config

- (void)configureScrollView
{
	self.scrollView.delegate = self;
	self.scrollView.bounces = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)configureRecentScreen
{
	self.recentCollectionView.delegate = self;
	self.recentCollectionView.dataSource = self;
}

- (void)configureGroupScreen
{
	self.groupCollectionView.delegate = self;
	self.groupCollectionView.dataSource = self;
}

- (void)configureNearbyScreen
{
	self.nearbyCollectionView.delegate = self;
	self.nearbyCollectionView.dataSource = self;
}

- (void)configureAllScreen
{
	self.allTableView.delegate = self;
	self.allTableView.dataSource = self;
}

#pragma mark
#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return (1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (collectionView == self.recentCollectionView)
	{
		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

		return (cell);
	}
	else if (collectionView == self.groupCollectionView)
	{
		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

		return (cell);
	}
	else // self.nearbyCollectionView
	{
		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

		return (cell);
	}
}

#pragma mark
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (1);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	return (cell);
}

@end
