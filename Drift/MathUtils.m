//
//  MathUtils.m
//  Drift
//
//  Created by Clément Georgel on 19/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "MathUtils.h"
#include <math.h>

@implementation MathUtils

+(double) distanceCartesienne:(CLLocationCoordinate2D) a b:(CLLocationCoordinate2D)b
{
    return sqrt(pow(b.latitude - a.latitude, 2) + pow(b.longitude - a.longitude, 2));
}

+(double) distanceHaversine:(CLLocationCoordinate2D) pointA b:(CLLocationCoordinate2D)pointB
{
    double lat1 = pointA.latitude;
    double lat2 = pointB.latitude;
    double lon1 = pointA.longitude;
    double lon2 = pointB.longitude;
    double R = 6371; // Radius of the earth in km
    double dLat = [self deg2rad:(lat2-lat1)];  // deg2rad below
    double dLon = [self deg2rad:(lon2-lon1)];
    double a = sin(dLat/2) * sin(dLat/2) +
    cos([self deg2rad:(lat1)]) * cos([self deg2rad:(lat2)]) *
    sin(dLon/2) * sin(dLon/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = R * c; // Distance in km
    return d;
}

+(double) deg2rad:(double)deg{
    return deg * (M_PI/180);
}

@end
