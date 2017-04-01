//
//  DFTFeedManager.m
//  Drift
//
//  Created by Thierry Ng on 22/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTNetworkClient+DFTDrop.h"
#import "DFTFeedManager.h"
#import "DFTDrop.h"

#import <SDWebImagePrefetcher.h>

@implementation DFTFeedManager

- (void)buildFeedWithCompletion:(DFTManagerCompletion)completion
{
	DFTNetworkClient *networkClient = [DFTNetworkClient sharedInstance];

	[networkClient getGlobalFeedDropsForPosition: CLLocationCoordinate2DMake(0, 0) withCompletion:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject, NSError * _Nullable error)
	 {
		 if (error || ![responseObject[@"ReturnCode"] isEqualToString:@"BEA_GET_ALL_GPS_OK"])
		 {
			 NSLog(@"Network get beacons by GPS error : %@", error);
			 return ;
		 }

		 NSLog(@"response = %@", responseObject);
		 NSError *sError = nil;

		 NSArray<DFTDrop *> *drops = [MTLJSONAdapter modelsOfClass:[DFTDrop class]
													 fromJSONArray:responseObject[@"ReturnMessage"]
															 error:&sError];

		 if (!sError)
		 {
			 NSMutableArray *urls = @[].mutableCopy;

			 for (DFTDrop *drop in drops)
			 {
				 [urls addObject:[NSString stringWithFormat:@"http://drift.braycedenayce.com/drift_api/beacon/pic/%@", drop.dropId]];
			 }
			 [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls];
			 if (completion)
				 completion(drops, sError);
		 }
		 else
			 NSLog(@"User serialisation error");
	 }];
}

@end
