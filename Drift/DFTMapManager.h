//
//  DFTMapManager.h
//  Drift
//
//  Created by Thierry Ng on 27/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>

#import "DFTDrop.h"

@interface DFTMapManager : NSObject <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;

- (void)addMapToView:(UIView *)view withDelegate:(id)delegate;
- (CLLocationCoordinate2D)userCoordinates;

- (void) setCenterCoordinate;
- (void) setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate;
- (void) setCenterCoordinateWithZoom:(int)zoomLevel;
- (void) setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(int) zoomLevel;

+ (instancetype)sharedInstance;
- (void)addDropsToMap:(NSArray<DFTDrop *> *)drops;
- (void)removeAllDropsToMap;

@end
