//
//  DFTFeedViewController.m
//  Drift
//
//  Created by Thierry Ng on 26/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTGlobalFeedViewController.h"
#import "DFTFeedCollectionViewLayout.h"
#import "DFTOpenedDropViewController.h"
#import "DFTMapManager.h"

#import "DFTFeedCell.h"

@interface DFTGlobalFeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    @private
    NSIndexPath *selectedIndexPath;
}
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
	DFTFeedManager *manager = [DFTFeedManager new];

	[manager buildFeedWithCompletion:^(id  _Nullable responseObject, NSError * _Nullable error)
	{
		self.drops = responseObject;
		[self.collectionView reloadData];
	}];
	[self configureCollectionView];
}

/*- (void)viewDidLayoutSubviews
{
	CAShapeLayer *layer = [CAShapeLayer layer];
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.collectionView.bounds
													 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
														   cornerRadii:CGSizeMake(3.0, 3.0)];
	layer.frame = self.collectionView.bounds;
	layer.path = path.CGPath;
	self.collectionView.layer.mask = layer;
}*/

//- layoutsubviews
//override public func layoutSubviews() {
//	super.layoutSubviews()
//	roundCorners(corners: [.bottomLeft, .bottomRight], radius: UIFlashLabel.cornerRadius)
//}



- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
//    self.collectionView.contentOffset= CGPointMake(0, -100);
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

- (void)becameVisibleFeed
{

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
	return (self.drops.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	DFTFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(NSString *)feedCellIdentifier forIndexPath:indexPath];

	[cell configureWithDrop:self.drops[indexPath.item]];

	if (indexPath.item == 0)
		[cell roundCorner:UIRectCornerTopLeft withSize:(CGSize){8., 8.}];
	else if (indexPath.item == 1)
		[cell roundCorner:UIRectCornerTopRight withSize:(CGSize){8., 8.}];

	return (cell);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"showDrop" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DFTOpenedDropViewController *viewController = segue.destinationViewController;

	if ([segue.identifier isEqualToString:@"showDrop"])
        viewController.drop = self.drops[selectedIndexPath.item];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[super scrollViewDidScroll:scrollView];

	DFTFeedCell *cellLeft = (DFTFeedCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
	DFTFeedCell *cellRight = (DFTFeedCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

	CGFloat radii = MIN(8. - (scrollView.contentOffset.y / 6), 8.);

	[cellLeft roundCorner:UIRectCornerTopLeft withSize:(CGSize){radii, radii}];
	[cellRight roundCorner:UIRectCornerTopRight withSize:(CGSize){radii, radii}];
}

@end
