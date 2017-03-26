//
//  DriftViewController.m
//  Drift
//
//  Created by Thierry Ng on 26/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDriftViewController.h"
#import "DFTDrop.h"
#import "DFTMapManager.h"
#import "DFTInnerFeedCell.h"


@interface DFTDriftViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<DFTDrop *> *dropsArray;

@end

@implementation DFTDriftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self configureCollectionView];
	[self configureMap];
    self.dropsArray = (NSArray<DFTDrop*> *) [[[DFTMapManager sharedInstance]mapView]annotations];
}

- (void)configureCollectionView
{
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;

	UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];

	layout.itemSize = (CGSize){self.view.frame.size.width, 167};
	layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

	self.collectionView.backgroundColor = [UIColor clearColor];
	self.collectionView.collectionViewLayout = layout;
	self.collectionView.showsHorizontalScrollIndicator = NO;
	self.collectionView.pagingEnabled = YES;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DFTInnerFeedCell" bundle:nil] forCellWithReuseIdentifier:@"DFTInnerFeedCell"];
}

- (void)configureMap
{
	[[DFTMapManager sharedInstance] addMapToView:self.view withDelegate:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return (1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[DFTMapManager sharedInstance] mapView].annotations.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DFTInnerFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DFTInnerFeedCell" forIndexPath:indexPath];
    
    DFTDrop  *point = (DFTDrop *) [self.dropsArray objectAtIndex:indexPath.row];
    [cell configureWithItem:point];
    [cell updateConstraintWithValue:10];
    return cell;
}


- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView
{
	[mapView
	 setCenterCoordinate:[[DFTMapManager sharedInstance] userCoordinates]
	 zoomLevel:15
	 animated:YES];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation
{
	return (nil);
}

// Allow callout view to appear when an annotation is tapped.
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation
{
	return (NO);
}

- (void)mapView:(MGLMapView *)mapView didSelectAnnotation:(DFTDrop *)annotation
{
	NSLog(@"%@", [annotation title]);
    
    NSInteger annotationIndex = [self.dropsArray indexOfObject:annotation];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:annotationIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:TRUE];
}



#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems]firstObject];
}

@end
