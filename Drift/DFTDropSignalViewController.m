//
//  DFTDropSignalViewController.m
//  Drift
//
//  Created by Thierry Ng on 16/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDropSignalViewController.h"
#import "UIColor+DFTStyles.h"
#import "DFTUserManager.h"

#import "DFTUserGroupCell.h"

#import <UIImageView+AFNetworking.h>

@interface DFTDropSignalViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

#pragma mark screens
@property (weak, nonatomic) IBOutlet UICollectionView *recentCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *groupCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *nearbyCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *allTableView;

#pragma mark datas
@property NSArray<DFTUser *> *allDataSource;

@end

@implementation DFTDropSignalViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	DFTUserManager *manager = [DFTUserManager new];

	[manager allUsersWithCompletion:^(id  _Nullable responseObject, NSError * _Nullable error) {
		NSLog(@"%@", responseObject);
		self.allDataSource = responseObject;
		[self.allTableView reloadData];
	}];

	self.titleImageView.tintColor = [UIColor dft_salmonColor];
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

	[self.groupCollectionView registerNib:[UINib nibWithNibName:@"DFTUserGroupCell" bundle:nil] forCellWithReuseIdentifier:@"GroupCell"];
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
	self.allTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (IBAction)dismissScreen:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
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
		DFTUserGroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupCell" forIndexPath:indexPath];

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
	return (1 + self.allDataSource.count);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

	[cell viewWithTag:42 + indexPath.row].backgroundColor = [UIColor dft_salmonColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

	[cell viewWithTag:42 + indexPath.row].backgroundColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	UIView *view = [UIView new];

	view.frame = CGRectMake(0., 0., 26., 26.);
	view.backgroundColor = [UIColor whiteColor];
	view.layer.cornerRadius = 13.;
	view.clipsToBounds = YES;
	view.tag = 42 + indexPath.row;
	cell.accessoryView = view;

	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	if (indexPath.row > 0)
	{
		DFTUser *user = self.allDataSource[indexPath.row - 1];

//		[cell.imageView setImageWithURL:user. placeholderImage:nil];
		cell.imageView.image = [UIImage imageNamed:@"feed_cell_profile_pic_placeholder"];
		cell.imageView.layer.cornerRadius = 19.25;
		cell.imageView.clipsToBounds = YES;

		cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.text = user.firstName;
		cell.detailTextLabel.text = @"";
		cell.detailTextLabel.textColor = [UIColor whiteColor];
	}
	return (cell);
}

@end
