//
//  DFTProfileViewController.m
//  Drift
//
//  Created by Thierry Ng on 05/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTProfileViewController.h"
#import "DFTFeedManager.h"
#import "DFTFeedCell.h"

#import "DFTSegmentedControl.h"

@interface DFTProfileViewController () <DFTSegmentedControlDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray<DFTDrop *> *dropsArray;

@property (weak, nonatomic) IBOutlet UIView *segmentedContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePictureBottomMargin;

@property (strong, nonatomic) DFTSegmentedControl *segmentedControl;

@end

@implementation DFTProfileViewController

@synthesize imgCover, imgProfile, imgMapCheck, lblName, lblRank, lblDrops, lblTitle, lblDrifts, lblFriends, lblNbDrops, lblNbDrifts, lblPosition, lblCountries, lblFollowers, lblFollowing, lblLastCheck, lblNbFriends,  lblDescription, lblNbCountries, lblNbFollowers, lblNbFollowing, lblLastCheckTime, lblHeaderLikedDrops, btnSettings, driftDropOverviewScrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];

	[[DFTFeedManager new] buildFeedWithCompletion:^(id  _Nullable responseObject, NSError * _Nullable error)
	{
		self.dropsArray = responseObject;
	}];

	[self configureScrollView];
	[self configureSegmentedControl];
	[self configureHeader];
	[self configureMostLikedCollectionView];
	[self configureOverview];
}

- (void)configureHeader
{
	imgProfile.image = [UIImage imageNamed:@"feed_cell_profile_pic_placeholder"];
}

- (void)configureScrollView
{
//	self.scrollView.contentSize = (CGSize){self.view.bounds.size.width, self.view.bounds.size.height * 2};
	self.scrollView.delegate = self;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.bounces = NO;
}

- (void)configureOverview
{
	self.driftDropOverviewScrollView.pagingEnabled = YES;
	self.driftDropOverviewScrollView.showsHorizontalScrollIndicator = NO;
}

- (void)configureSegmentedControl
{
	self.segmentedControl = [[[NSBundle mainBundle] loadNibNamed:@"DFTSegmentedControl" owner:self options:nil] lastObject];
	self.segmentedControl.delegate = self;
	[self.segmentedContainerView addSubview:self.segmentedControl];
}

- (void)configureMostLikedCollectionView
{
	NSString *cellNibName = NSStringFromClass([DFTFeedCell class]);

	self.mostLikedCollectionView.dataSource = self;
	self.mostLikedCollectionView.delegate = self;
	[self.mostLikedCollectionView registerNib:[UINib nibWithNibName:cellNibName bundle:nil] forCellWithReuseIdentifier:cellNibName];

	UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];

	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	layout.minimumInteritemSpacing = 4.;
	layout.minimumLineSpacing = 4.;
	layout.sectionInset = (UIEdgeInsets){0, 0, 0, 0};
	self.mostLikedCollectionView.collectionViewLayout = layout;

	self.mostLikedCollectionView.showsHorizontalScrollIndicator = NO;
}

- (IBAction)actSettings:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SuperTitle", nil)
                                message:NSLocalizedString(@"SuperMsg", nil)
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil] show];
}

#pragma mark
#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView == self.scrollView)
	{
		self.headerTopConstraint.constant = -((scrollView.contentOffset.y) / 7);
		self.headerView.alpha = (1 - (scrollView.contentOffset.y / self.headerView.frame.size.height));

		NSLog(@"%f", self.headerView.alpha);
		[btnSettings setUserInteractionEnabled:(self.headerView.alpha >= 0.95)];
	}
}

#pragma mark
#pragma mark - DFTSegmentedControl Delegate

- (void)segmentedControlValueChanged:(NSInteger)index
{
	// Replace by custon self-made views
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Titre" message:@"message message message message message message message" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Fermer" style:UIAlertActionStyleDefault handler:nil];

	[alert addAction:okAction];
	[self presentViewController:alert animated:YES completion:nil];
}

#pragma mark
#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return (24);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return (indexPath.item == 0 ? (CGSize){150, 100} : (CGSize){48, 48});
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.item != 0)
	{
		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlainCell" forIndexPath:indexPath];

		cell.backgroundColor = [UIColor cyanColor];
		return (cell);
	}
	DFTFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DFTFeedCell" forIndexPath:indexPath];

	[cell configureWithDrop:nil];
	[cell hideProfilePic];
	return (cell);
}

@end
