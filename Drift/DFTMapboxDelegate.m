//
//  DFTMapboxDelegate.m
//  Drift
//
//  Created by Thierry Ng on 29/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTMapboxDelegate.h"

@implementation DFTMapboxDelegate

- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView
{
	NSLog(@"Map finished loading.");
}

- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id<MGLAnnotation>)annotation
{
	NSLog(@"BLAJ");
	return (nil);
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation
{
	NSLog(@"sfuhgsoudjo");
	return (nil);
}

- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation
{
	CLLocationCoordinate2D coordinate;

	coordinate = (CLLocationCoordinate2D)
	{
		userLocation.location.coordinate.latitude - 38,
		userLocation.location.coordinate.longitude
	};
	[mapView setCenterCoordinate:coordinate];
}

@end
