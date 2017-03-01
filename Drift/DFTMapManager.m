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

	// Add marker `hello` to the map
	MGLPointAnnotation *point1 = [[MGLPointAnnotation alloc] init];
	point1.coordinate = CLLocationCoordinate2DMake(51.510082, -0.133850);
	point1.title = @"point1";

	MGLPointAnnotation *point2 = [[MGLPointAnnotation alloc] init];
	point2.coordinate = CLLocationCoordinate2DMake(51.511089, -0.136188);
	point2.title = @"point2";

	MGLPointAnnotation *point3 = [[MGLPointAnnotation alloc] init];
	point3.coordinate = CLLocationCoordinate2DMake(51.509882, -0.131559);
	point3.title = @"point3";

	MGLPointAnnotation *point4 = [[MGLPointAnnotation alloc] init];
	point4.coordinate = CLLocationCoordinate2DMake(51.510590, -0.131287);
	point4.title = @"point4";

	MGLPointAnnotation *point5 = [[MGLPointAnnotation alloc] init];
	point5.coordinate = CLLocationCoordinate2DMake(51.510947, -0.134521);
	point5.title = @"point5";

	MGLPointAnnotation *point6 = [[MGLPointAnnotation alloc] init];
	point6.coordinate = CLLocationCoordinate2DMake(51.509524, -0.135212);
	point6.title = @"point6";

	[self.mapView addAnnotation:point1];
	[self.mapView addAnnotation:point2];
	[self.mapView addAnnotation:point3];
	[self.mapView addAnnotation:point4];
	[self.mapView addAnnotation:point5];
	[self.mapView addAnnotation:point6];
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
