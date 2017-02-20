//
//  DFTNetworkClient.h
//  Drift
//
//  Created by Thierry Ng on 17/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark Block

typedef void (^DFTNetworkCompletion)(NSURLSessionDataTask *dataTask,
									  id  _Nullable responseObject,
									  NSError * _Nullable error);

@interface DFTNetworkClient : AFHTTPSessionManager

#pragma mark -
#pragma mark Custom init

- (instancetype)initWithDFTTestEnvironement;
- (instancetype)initWithDFTProdEnvironement;

#pragma mark -
#pragma mark Singleton

+ (instancetype)sharedInstanceWithBaseURL:(NSURL *)baseURL;
+ (instancetype)sharedInstance;

#pragma mark -
#pragma mark Session Token

/* Feed the session token yourself after calling the `createSessionWithUserRef:andPassword:completion:`method
 */
- (void)updateSessionToken:(NSString *)newToken;

#pragma mark -
#pragma mark Retry

- (void)retryDataTask:(NSURLSessionDataTask *)dataTask;

#pragma mark -
#pragma mark Session Create

- (void)createSessionWithUserIdentifier:(NSString *)identifier
							   password:(NSString *)password
							   timestamp:(NSString *)timestamp
							   secret:(NSData *)secret
							 completion:(nullable DFTNetworkCompletion)completion;
- (void)closeSessionWithCompletion:(nullable DFTNetworkCompletion)completion;

@end

NS_ASSUME_NONNULL_END
