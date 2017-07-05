//
//  DFTDropManager.m
//  Drift
//
//  Created by Thierry Ng on 04/07/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTNetworkClient+DFTDrop.h"
#import "DFTDropManager.h"

#import "DFTUser.h"
#import "DFTSessionManager.h"

@implementation DFTDropManager

- (void)createDrop:(DFTDrop *)drop withCompletion:(DFTManagerCompletion)completion
{
	drop.ownerId = @([[DFTSessionManager currentSession].user.userId integerValue]);
	[[DFTNetworkClient sharedInstance] createDrop:drop withCompletion:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject, NSError * _Nullable error) {
		NSLog(@"%@", responseObject);
		NSLog(@"error : %@", error);
	}];
}


@end
