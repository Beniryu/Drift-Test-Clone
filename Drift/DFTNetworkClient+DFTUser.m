//
//  DFTNetworkClient+DFTUser.m
//  Drift
//
//  Created by Thierry Ng on 03/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTNetworkClient+DFTUser.h"

static const NSString *kDFTNetworkRouteUserCreate = @"user/create";
static const NSString *kDFTNetworkRouteUserEdit = @"user/edit";

@implementation DFTNetworkClient (DFTUser)

- (void)createUser:(DFTUser *)user withCompletion:(DFTNetworkCompletion)completion
{
	NSDictionary *parameters = nil;
	NSError *serialError = nil;

	parameters = [MTLJSONAdapter JSONDictionaryFromModel:user error:&serialError];

	if (!serialError)
	{
		[self POST:(NSString *)kDFTNetworkRouteUserCreate
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

- (void)editUser:(DFTUser *)user withCompletion:(DFTNetworkCompletion)completion
{
	NSDictionary *parameters = nil;
	NSError *serialError = nil;

	parameters = [MTLJSONAdapter JSONDictionaryFromModel:user error:&serialError];

	if (!serialError)
	{
		[self POST:(NSString *)kDFTNetworkRouteUserEdit
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

- (void)deleteUser:(DFTUser *)user withCompletion:(DFTNetworkCompletion)completion
{
	NSDictionary *parameters = nil;
	NSError *serialError = nil;

	parameters = [MTLJSONAdapter JSONDictionaryFromModel:user error:&serialError];

	if (!serialError)
	{
		[self DELETE:@"user/"
		  parameters:parameters
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

@end
