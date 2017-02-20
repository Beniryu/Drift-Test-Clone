//
//  DFTObject.m
//  Drift
//
//  Created by Thierry Ng on 03/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTObject.h"

@implementation DFTObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
	return (nil);
}

+ (NSDateFormatter *)dateFormatter
{
	NSDateFormatter *df = [NSDateFormatter new];

	df.locale = [NSLocale localeWithLocaleIdentifier:@"fr_FR"];
	df.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Paris"];
	df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	return (df);
}

+ (MTLValueTransformer *)commonValueTransformerForDate
{
	return
	[MTLValueTransformer transformerUsingForwardBlock:
	 ^id(id value, BOOL *success, NSError *__autoreleasing *error)
	 {
		 return ([[self dateFormatter] dateFromString:value]);
	 } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error)
	 {
		 return [[self dateFormatter] stringFromDate:value];
	 }];
}

@end
