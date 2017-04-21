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
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

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
	self.searchTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon"]];
}

#pragma mark
#pragma mark - Config

- (void)configureScrollView
{
	self.scrollView.delegate = self;
	self.scrollView.bounces = NO;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)configureSegmentedControl
{

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

	self.allTableView.allowsMultipleSelection = YES;
	self.allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark
#pragma mark - Screen Flow

- (IBAction)didChangeSegment:(id)sender
{
	CGRect rect;

	if (self.segmentedControl.selectedSegmentIndex == 0)
		rect = self.recentCollectionView.superview.frame;
	else if (self.segmentedControl.selectedSegmentIndex == 1)
		rect = self.groupCollectionView.superview.frame;
	else if (self.segmentedControl.selectedSegmentIndex == 2)
		rect = self.nearbyCollectionView.superview.frame;
	else
		rect = self.allTableView.superview.frame;
	[self.scrollView scrollRectToVisible:rect animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView == self.scrollView)
	{
		CGFloat offsetX = self.scrollView.contentOffset.x;

		if (offsetX == 0)
			self.segmentedControl.selectedSegmentIndex = 0;
		else if (offsetX == self.scrollView.frame.size.width)
			self.segmentedControl.selectedSegmentIndex = 1;
		else if (offsetX == self.scrollView.frame.size.width * 2)
			self.segmentedControl.selectedSegmentIndex = 2;
		else if (offsetX == self.scrollView.frame.size.width * 3)
			self.segmentedControl.selectedSegmentIndex = 3;
	}
}

#pragma mark
#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return (0);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return (55.);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	UIView *view = [UIView new];

	view.frame = CGRectMake(0., 0., 30., 30.);
	view.backgroundColor = [UIColor redColor];
	view.layer.cornerRadius = 15.;
	view.clipsToBounds = YES;
	cell.accessoryView = view;
	cell.imageView.image = [UIImage imageNamed:@"feed_cell_profile_pic_placeholder"];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.text = @"Name of contact";
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return (cell);
}

@end
