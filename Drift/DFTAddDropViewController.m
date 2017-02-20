//
//  DFTAddDropViewController.m
//  Drift
//
//  Created by Thierry Ng on 17/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTAddDropViewController.h"

@interface DFTAddDropViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DFTAddDropViewController

#pragma mark
#pragma mark - UICollectionView

- (void)viewDidLoad
{
    [super viewDidLoad];

	NSLog(@"viewDidLoad");
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	NSLog(@"viewDidAppear");
}

#pragma mark
#pragma mark - UICollectionView

- (void)configureCollectionView
{
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
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
	UICollectionViewCell *cell;

	return (cell);
}

@end
