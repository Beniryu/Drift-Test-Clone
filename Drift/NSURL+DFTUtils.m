//
//  NSURL+DFTUtils.m
//  Drift
//
//  Created by Thierry Ng on 17/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "NSURL+DFTUtils.h"

static const NSString *DFTURLSecureScheme = @"https://";
static const NSString *DFTURLNonSecureScheme = @"http://";

@implementation NSURL (DFTUtils)

+ (NSURL *)dft_baseURL:(NSString *)url secured:(BOOL)secured
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
								 secured ? DFTURLSecureScheme : DFTURLNonSecureScheme,
								 url]];
}

@end
