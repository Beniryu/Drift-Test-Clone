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
#import "ImageUtils.h"
#import "MathUtils.h"

@interface DFTDriftViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSDateFormatter *dateDayFormatter;
    NSDateFormatter *dateMonthFormatter;
@private
DFTDrop *activeDrop;
MGLMapView *mapViewShared;
    NSArray *alphaToAnimate;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<DFTDrop *> *dropsArray;

@property (strong, nonatomic) DFTSegmentedControl *segmentedControl;

@end

@implementation DFTDriftViewController

@synthesize lblLocation, lblDropFound, lblNbDropFound, segmentedControl;

static const double MAX_DISTANCE_KM_AUTHORIZED  = 1;

int dynamicRow;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dateDayFormatter = [[NSDateFormatter alloc] init];
    [dateDayFormatter setDateFormat:@"dd"];
    
    dateMonthFormatter = [[NSDateFormatter alloc] init];
    [dateMonthFormatter setDateFormat:@"MMM"];
    
    alphaToAnimate = @[_imgClose,
                       _lblShares,
                       _lblNbShares,
                       _lblLikes,
                       _lblNbLikes,
                       _lblDrifters,
                       _lblNbDrifters,
                       _imgProfil,
                       _lblName,
                       _vLocation,
                       _lblDistance,
                       _btnPlus,
                       _lblNameEvent,
                       _lblDay,
                       _lblMonth,
                       _btnLike,
                       _lblTags,
                       _lblDescription,
                       _imgDrifter1,
                       _imgDrifter2,
                       _imgDrifter3,
                       _vMenuRight];
    
    dynamicRow = -1;
	[self configureCollectionView];
	[self configureMap];
    [self configureSegmentedControl];
	//    self.dropsArray = (NSArray<DFTDrop*> *) [[[DFTMapManager sharedInstance]mapView]annotations];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureMap];
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
    
	[[DFTMapManager sharedInstance] addMapToView:self.view withDelegate:self];

	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_mask"]];

    mapViewShared = [DFTMapManager sharedInstance].mapView;
	imageView.frame = mapViewShared.frame;
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	[mapViewShared addSubview:imageView];
}

- (void)configureDetails
{
    if( activeDrop )
    {
        _lblNbLikes.text = [NSString stringWithFormat:@"%d", (int)activeDrop.likes];
        _lblNbDrifters.text = [NSString stringWithFormat:@"%d", (int)activeDrop.drifts];
        _lblNbShares.text = [NSString stringWithFormat:@"%d", (int)activeDrop.shares];
        
        _lblNameEvent.text = activeDrop.title;
        _lblDay.text = @"24";//[dateDayFormatter stringFromDate:activeDrop.dropDate];
        _lblMonth.text = @"APR";//[dateMonthFormatter stringFromDate:activeDrop.dropDate];
        
        _imgProfil.image = activeDrop.profilePicture;
    }
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
    activeDrop = drop;
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

- (BOOL)mapView:(MGLMapView *)mapView shouldChangeFromCamera:(MGLMapCamera *)oldCamera toCamera:(MGLMapCamera *)newCamera
{
    if( [MathUtils distanceHaversine:[[DFTMapManager sharedInstance] userCoordinates] b:newCamera.centerCoordinate] > MAX_DISTANCE_KM_AUTHORIZED )
    {
        [self mapViewDidFinishLoadingMap:mapView];
        return NO;
    }
    return YES;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems]firstObject];
}

#pragma mark - Pan Gesture actions

- (IBAction)actExpandCell:(UISwipeGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded )
    {
        [self configureDetails];
        
        CGFloat pageWidth = self.collectionView.frame.size.width;
        int currentPage = self.collectionView.contentOffset.x / pageWidth;
        DFTInnerFeedCell *cell = (DFTInnerFeedCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0]];
        
        _imgAnimated.frame = [cell convertRect:cell.imageView.frame toView:_vDetails];
        [self.view layoutIfNeeded];
        
        [ImageUtils roundedBorderImageView:_imgProfil];
        [ImageUtils roundedBorderImageView:_imgDrifter1];
        [ImageUtils roundedBorderImageView:_imgDrifter2];
        [ImageUtils roundedBorderImageView:_imgDrifter3];
        [UIView animateWithDuration:2. animations:^{
            _imgAnimated.frame = _imgPlaceholder.frame;
            _imgAnimated.layer.cornerRadius = 6.;
            _imgAnimated.clipsToBounds = YES;
            _imgAnimated.alpha = 1;
            _imgAnimated.image = cell.imageView.image;
        }];
        [UIView animateWithDuration:1.
                              delay:.5
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                _vDetails.alpha = 1;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:1.
                                      delay:0.
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     for( UIControl *element in alphaToAnimate)
                                         element.alpha = 1;
                                 } completion:nil];
            }];
    }
}

- (IBAction)actCloseCell:(id)sender
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    int currentPage = self.collectionView.contentOffset.x / pageWidth;
    DFTInnerFeedCell *cell = (DFTInnerFeedCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0]];
    
    [UIView animateWithDuration:2. animations:^{
        _imgAnimated.frame = [cell convertRect:cell.imageView.frame toView:_vDetails];
        _imgAnimated.alpha = 0;
    }];
    [UIView animateWithDuration:1.
                          delay:.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _vDetails.alpha = 0;
                     } completion:^(BOOL finished){
                         [UIView animateWithDuration:1.
                                               delay:0.
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              for( UIControl *element in alphaToAnimate)
                                                  element.alpha = 0;
                                          } completion:nil];
                     }];
}

- (IBAction)actExpandMenu:(id)sender
{
    [UIView animateWithDuration:1.
                          delay:0.
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _vMenuRight.frame = _vMenuPlaceholder.frame;
                     } completion:^(BOOL finished){
                     }];
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _vMarkIt.alpha = 1;
                     } completion:nil];
    
}

- (IBAction)actMarkIt:(id)sender
{
    [UIView animateWithDuration:1.
                          delay:0.
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _vMarkIt.alpha = 0;
                     } completion:^(BOOL finished){
                     }];
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _vMenuRight.frame = _vMenuOrigin.frame;
                     } completion:nil];
}

@end
