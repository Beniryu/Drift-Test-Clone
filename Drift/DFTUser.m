//
//  DFTUser.m
//  Drift
//
//  Created by Thierry Ng on 03/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTUser.h"
#import <Mantle.h>

#pragma mark
#pragma mark - JSON Keys

const NSString *kDFTModelKeyUserId = @"IdUser";
const NSString *kDFTModelKeyIdentifier = @"Identifier";
const NSString *kDFTModelKeyEmail = @"Mail";
const NSString *kDFTModelKeyLastName = @"LastName";
const NSString *kDFTModelKeyFirstName = @"FirstName";
NSString *kDFTModelKeyRegistration = @"Registration";
NSString *kDFTModelKeyLastConnection = @"Connection";

@implementation DFTUser

#pragma mark
#pragma mark - De-serialization Protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
	return (@{
			  NSStringFromSelector(@selector(userId)) : kDFTModelKeyUserId,
			  NSStringFromSelector(@selector(identifier)) : kDFTModelKeyIdentifier,
			  NSStringFromSelector(@selector(email)) : kDFTModelKeyEmail,
			  NSStringFromSelector(@selector(lastName)) : kDFTModelKeyLastName,
			  NSStringFromSelector(@selector(firstName)) : kDFTModelKeyFirstName,
			  NSStringFromSelector(@selector(registration)) : kDFTModelKeyRegistration,
			  NSStringFromSelector(@selector(lastConnection)) : kDFTModelKeyLastConnection
			  });
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
	if ([key isEqualToString:NSStringFromSelector(@selector(registration))] ||
		 [key isEqualToString:NSStringFromSelector(@selector(lastConnection))])
		return ([self commonValueTransformerForDate]);
	return (nil);
}

@end
