//
//  DFTDrop.m
//  Drift
//
//  Created by Thierry Ng on 24/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTDrop.h"
#import <Mantle.h>

#pragma mark
#pragma mark - JSON Keys

const NSString *kDFTModelKeyDropId = @"IdBeacon";
const NSString *kDFTModelKeyDropLatitude = @"Latitude";
const NSString *kDFTModelKeyDropLongitude = @"Longitude";
const NSString *kDFTModelKeyDropDate = @"DateTime";
const NSString *kDFTModelKeyDropOwnerId = @"OwnerId";
const NSString *kDFTModelKeyDropTitle = @"Title";
const NSString *kDFTModelKeyDropPicture = @"BackgroundPicture";
const NSString *kDFTModelKeyDropMapVisibility = @"MapVisibility";
const NSString *kDFTModelKeyDropContentVisibility = @"ContentVisibility";
const NSString *kDFTModelKeyDropLikes = @"Likes";
const NSString *kDFTModelKeyDropDrifts = @"Drifts";
const NSString *kDFTModelKeyDropShares = @"Share";

@implementation DFTDrop

#pragma mark
#pragma mark - De-serialization Protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
	return (@{
			  NSStringFromSelector(@selector(dropId)) : kDFTModelKeyDropId,
			  NSStringFromSelector(@selector(latitude)) : kDFTModelKeyDropLatitude,
			  NSStringFromSelector(@selector(longitude)) : kDFTModelKeyDropLongitude,
			  NSStringFromSelector(@selector(dropDate)) : kDFTModelKeyDropDate,
			  NSStringFromSelector(@selector(ownerId)) : kDFTModelKeyDropOwnerId,
			  NSStringFromSelector(@selector(title)) : kDFTModelKeyDropTitle,
			  NSStringFromSelector(@selector(backgroundPicture)) : kDFTModelKeyDropPicture,
			  NSStringFromSelector(@selector(mapVisibility)) : kDFTModelKeyDropMapVisibility,
			  NSStringFromSelector(@selector(contentVisibility)) : kDFTModelKeyDropContentVisibility,
			  NSStringFromSelector(@selector(likes)) : kDFTModelKeyDropLikes,
			  NSStringFromSelector(@selector(drifts)) : kDFTModelKeyDropDrifts,
			  NSStringFromSelector(@selector(shares)) : kDFTModelKeyDropShares,
			  });
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
	if ([key isEqualToString:NSStringFromSelector(@selector(dropDate))])
		return ([self commonValueTransformerForDate]);
	return (nil);
}

@end
