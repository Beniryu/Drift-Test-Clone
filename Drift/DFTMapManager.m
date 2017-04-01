//
//  DFTMapManager.m
//  Drift
//
//  Created by Thierry Ng on 27/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTMapManager.h"

@implementation DFTMapManager

static const NSString *mapStyleURL = @"mapbox://styles/d10s/cisx8as7l002g2xr0ei3xfoip";

+ (instancetype)sharedInstance
{
	static dispatch_once_t onceToken;
	static id sharedObject = nil;

	dispatch_once(&onceToken, ^{
		sharedObject = [self new];
	});

	return (sharedObject);
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.mapView = [MGLMapView new];
		[self configureMapBox];
	}
	return self;
}

- (void)configureMapBox
{
	self.mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.mapView.styleURL = [NSURL URLWithString:(NSString *)mapStyleURL];
	self.mapView.showsUserLocation = YES;
//	self.mapView.zoomEnabled = NO;
	self.mapView.scrollEnabled = YES;

	self.mapView.delegate = self;
	self.mapView.attributionButton.hidden = YES;
}

- (void)addDropsToMap:(NSArray<DFTDrop *> *)drops
{
	for (DFTDrop *drop in drops)
		[self.mapView addAnnotation:drop];
}


- (CLLocationCoordinate2D)userCoordinates
{
	return ([DFTMapManager sharedInstance].mapView.userLocation.location.coordinate);
}

- (void)addMapToView:(UIView *)view withDelegate:(id)delegate
{
	if (delegate)
		self.mapView.delegate = delegate;
	[self.mapView removeFromSuperview];
	self.mapView.frame = view.frame;
	[view insertSubview:self.mapView atIndex:0];
}

// Use the default marker. See also: our view annotation or custom marker examples.
- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView
{
	[mapView
	 setCenterCoordinate:[self userCoordinates]
	 zoomLevel:15
	 animated:NO];

}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation {
	return nil;
}

// Allow callout view to appear when an annotation is tapped.
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
	return NO;
}

- (void)mapView:(MGLMapView *)mapView didSelectAnnotation:(id<MGLAnnotation>)annotation
{
	NSLog(@"%@", [annotation title]);
}

@end
