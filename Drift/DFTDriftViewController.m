;//
//  DriftViewController.m
//  Drift
//
//  Created by Thierry Ng on 26/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDriftViewController.h"
#import "DFTDrop.h"
#import "DFTFeedManager.h"
#import "DFTMapManager.h"
#import "DFTInnerFeedCell.h"


@interface DFTDriftViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
@private
DFTDrop *activeDrop;
MGLMapView *mapViewShared;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<DFTDrop *> *dropsArray;

@property (strong, nonatomic) DFTSegmentedControl *segmentedControl;

@end

@implementation DFTDriftViewController

@synthesize lblLocation, lblDropFound, lblNbDropFound, segmentedControl;

int dynamicRow;

- (void)viewDidLoad
{
    [super viewDidLoad];

    dynamicRow = -1;
	[self configureCollectionView];
	[self configureMap];
    [self configureSegmentedControl];
	//    self.dropsArray = (NSArray<DFTDrop*> *) [[[DFTMapManager sharedInstance]mapView]annotations];
	[[DFTFeedManager new] buildFeedWithCompletion:^(id  _Nullable responseObject, NSError * _Nullable error)
	{
		self.dropsArray = responseObject;
		[[DFTMapManager sharedInstance] addDropsToMap:self.dropsArray];
		[self.collectionView reloadData];
        if( self.dropsArray.count > 0 )
            activeDrop = [self.dropsArray objectAtIndex:0];
        lblNbDropFound.text = [NSString stringWithFormat:@"%d", (int)self.dropsArray.count];
        lblDropFound.text = NSLocalizedString(@"dropsFound", nil);
        lblLocation.text = @"LONDON";
	}];
}

- (void)configureSegmentedControl
{
    self.segmentedControl = [[[NSBundle mainBundle] loadNibNamed:@"DFTSegmentedControl" owner:self options:nil] lastObject];
    [self.segmentedControl configForDrift];
    self.segmentedControl.delegate = self;
    [self.segmentedContainerView addSubview:self.segmentedControl];
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

	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_mask"]];

    mapViewShared = [DFTMapManager sharedInstance].mapView;
	imageView.frame = mapViewShared.frame;
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	[mapViewShared addSubview:imageView];
}

#pragma mark - DFTSegmentedControl Delegate
- (void)segmentedControlValueChanged:(NSInteger)index
{
//    self.isManualScrolling = NO;
//
//	[self resetHeaders];
//    CGPoint point = (CGPoint){self.scrollView.frame.size.width * index, 0};
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"DFTFeedsScaleAnimation" object:self];
//    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self updateFeedType:index];
//        [self.scrollView setContentOffset:point];
//    } completion:nil];
}

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return (1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mapViewShared.annotations.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DFTInnerFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DFTInnerFeedCell" forIndexPath:indexPath];
    
    DFTDrop  *point = (DFTDrop *) [self.dropsArray objectAtIndex:indexPath.row];
    [cell configureWithItem:point];
    [cell updateConstraintWithValue:10];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    DFTDrop *drop;
    if( dynamicRow != -1 )
    {
        drop = (DFTDrop *) [self.dropsArray objectAtIndex:dynamicRow];
        dynamicRow = -1;
    }
    else
    {
        drop = (DFTDrop *) [self.dropsArray objectAtIndex:indexPath.row];
        //TODO: change icon drop how ?
    }
    
    DFTInnerFeedCell *myCell =  (DFTInnerFeedCell *)cell;
    [myCell configureWithItem:drop];
    [myCell updateConstraintWithValue:10];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{}

- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView
{
	[mapView setCenterCoordinate:[[DFTMapManager sharedInstance] userCoordinates] zoomLevel:15 animated:YES];
}

- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation
{
//	MGLAnnotationView *view = [[MGLAnnotationView alloc] initWithFrame:(CGRect){0, 0, 20, 20}];
//
//	view.backgroundColor = [UIColor cyanColor];
//	view.layer.cornerRadius = 6.;
//	view.clipsToBounds = YES;

	return (nil);
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation
{
	if (mapView.userLocation == annotation)
	{
		MGLAnnotationImage *image = [MGLAnnotationImage annotationImageWithImage:[UIImage imageNamed:@"User_annotation"] reuseIdentifier:@"user"];

		return (image);
	}
	MGLAnnotationImage *image = [MGLAnnotationImage annotationImageWithImage:[UIImage imageNamed:@"Annotation_image"] reuseIdentifier:@"drifting"];

	return (image);
}

// Allow callout view to appear when an annotation is tapped.
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation
{
	return (YES);
}

- (void)mapView:(MGLMapView *)mapView didSelectAnnotation:(DFTDrop *)annotation
{
    if( !activeDrop || (activeDrop && activeDrop != annotation))
    {
        activeDrop = annotation;
        
//        [[DFTMapManager sharedInstance].mapView setCenterCoordinate:annotation.coordinate animated:YES];
        NSInteger annotationIndex = [self.dropsArray indexOfObject:annotation];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:annotationIndex inSection:0];
        
        //Tentative de scroll slow -> Fonctionne bien mais on fake les cells dc quand on scroll vraiment et que l'on revient on peut ne pas avoir la même tuile qu'avant.
        CGFloat pageWidth = self.collectionView.frame.size.width;
        int currentPage = self.collectionView.contentOffset.x / pageWidth;
        
        BOOL leftToRight;
        int nextPage;
        if( currentPage + 1 >= 2 )
        {
            nextPage = currentPage -1;
            leftToRight = NO;
        }
        else
        {
            nextPage = currentPage + 1;
            leftToRight = YES;
        }
        dynamicRow = (int)indexPath.row;
        
        [UIView animateWithDuration:1
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             if( leftToRight )
                                 [self.collectionView setContentOffset:CGPointMake(pageWidth * nextPage - 1, 0)];
                             else
                                 [self.collectionView setContentOffset:CGPointMake(pageWidth * nextPage + 1, 0)];
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             [self.collectionView setContentOffset:CGPointMake(pageWidth * nextPage, 0)];
                         }];
        //    Old Version
        //    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems]firstObject];
}

@end
