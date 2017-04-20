//
//  MathUtils.h
//  Drift
//
//  Created by Clément Georgel on 19/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h> //TODO?

@interface MathUtils : NSObject

+(double) distanceCartesienne:(CLLocationCoordinate2D) a b:(CLLocationCoordinate2D)b;
+(double) distanceHaversine:(CLLocationCoordinate2D) pointA b:(CLLocationCoordinate2D)pointB;

@end
