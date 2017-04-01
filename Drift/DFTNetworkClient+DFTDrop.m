//
//  DFTNetworkClient+DFTDrop.m
//  Drift
//
//  Created by Thierry Ng on 22/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTNetworkClient+DFTDrop.h"

#import <Mantle.h>

#pragma mark -
#pragma mark Routes

static NSString *kDFTNetworkRouteDrop = @"beacon/";

@implementation DFTNetworkClient (DFTDrop)

- (void)retrieveDropWithId:(NSNumber *)dropID withCompletion:(DFTNetworkCompletion)completion
{
    NSString *route = [NSString stringWithFormat:@"%@/%@", kDFTNetworkRouteDrop, dropID];
    NSError *error = nil;
    
    if (error == nil)
    {
        [self GET:route
       parameters:nil
          progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
         {
             if (completion)
                 completion(task, responseObject, nil);
         }
           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             if (completion)
                 completion(task, nil, error);
         }];
    }

}

- (void)getGlobalFeedDropsForPosition:(CLLocationCoordinate2D)position withCompletion:(DFTNetworkCompletion)completion
{
	NSString *route = [NSString stringWithFormat:@"%@/getFromGPS/%f/%f", kDFTNetworkRouteDrop, (float)48.8727919, (float)2.3375631];
	NSError *error = nil;

	if (error == nil)
	{
		[self GET:route
	   parameters:nil
		 progress:nil
		  success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
		 {
			 if (completion)
				 completion(task, responseObject, nil);
		 }
		  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
		 {
			 if (completion)
				 completion(task, nil, error);
		 }];
	}

}

- (void)createDrop:(DFTDrop *)drop withCompletion:(DFTNetworkCompletion)completion
{
	NSString *route = [NSString stringWithFormat:@"%@/create", kDFTNetworkRouteDrop];
	NSDictionary *parameters = nil;
	NSError *error = nil;

	parameters = [MTLJSONAdapter JSONDictionaryFromModel:drop error:&error];

	if (error == nil)
	{
		[self POST:route
		parameters:parameters
		  progress:nil
		   success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
		 {
			 if (completion)
				 completion(task, responseObject, nil);
		 }
		   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
		 {
			 if (completion)
				 completion(task, nil, error);
		 }];
	}
}

- (void)editDrop:(DFTDrop *)drop withCompletion:(DFTNetworkCompletion)completion
{

}

- (void)deleteDrop:(DFTDrop *)drop withCompletion:(DFTNetworkCompletion)completion
{

}

@end
