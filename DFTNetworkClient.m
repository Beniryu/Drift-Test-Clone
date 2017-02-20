//
//  DFTNetworkClient.m
//  Drift
//
//  Created by Thierry Ng on 17/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTNetworkClient.h"
#import "NSURL+DFTUtils.h"
#import "PcURLRequestFormatter.h"


#pragma mark
#pragma mark - Base URL

static const NSString *kDFTNetworkTestEnvironementURL = @"https://drift.braycedenayce.com/drift_api";
static const NSString *kDFTNetworkProdEnvironementURL = @"https://drift.braycedenayce.com/drift_api";

#pragma mark
#pragma mark - Headers

static const NSString *kDFTNetworkHeaderSessionTokenKey = @"authorization";

#pragma mark
#pragma mark - Route

static const NSString *kDFTNetworkRouteAuth = @"authenticate/";

#pragma mark
#pragma mark - Request parameters

static const NSString *kDFTNetworkParamKeyIdentifier = @"Identifier";
static const NSString *kDFTNetworkParamKeyPassword = @"Password";
static const NSString *kDFTNetworkParamKeyTimestamp = @"DateTime";
static const NSString *kDFTNetworkParamKeySecret = @"Signature";

#pragma mark
#pragma mark - Interface

#pragma mark extension

@interface DFTNetworkClient ()

@property (nonatomic, weak) NSString *sessionToken;

@end

#pragma mark implementation

@implementation DFTNetworkClient

#pragma mark
#pragma mark - Accessors

- (void)setSessionToken:(NSString *)sessionToken
{
	_sessionToken = sessionToken;
	[self addSessionTokenHeader];
}

#pragma mark
#pragma mark - Singleton

static DFTNetworkClient *sharedInstance = nil;

+ (instancetype)sharedInstance
{
	static DFTNetworkClient *singleton = nil;
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^ {
		singleton = [[DFTNetworkClient alloc] initWithURL:nil];
	});
	return singleton;
}

+ (instancetype)sharedInstanceWithBaseURL:(NSURL *)baseURL
{
	static DFTNetworkClient *singleton = nil;
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^ {
		singleton = [[DFTNetworkClient alloc] initWithURL:baseURL];
	});
	return singleton;
}

- (instancetype)initWithURL:(NSURL *)url
{
	if (url)
		self = [super initWithBaseURL:url];
	else
		self = [super initWithBaseURL:[NSURL URLWithString:kDFTNetworkTestEnvironementURL]];

	if (!self)
		return nil;

	self.securityPolicy.allowInvalidCertificates = NO;
	self.securityPolicy.validatesDomainName = NO;

//	self.requestSerializer = [AFJSONRequestSerializer serializer];
	self.requestSerializer.timeoutInterval = 20.0;
	return self;
}

#pragma mark -
#pragma mark Init Custom

- (instancetype)initWithDFTTestEnvironement
{
	self = [self initWithURL:[NSURL dft_baseURL:(NSString *)kDFTNetworkTestEnvironementURL secured:YES]];
	return self;
}

- (instancetype)initWithDFTProdEnvironement
{
	self = [self initWithURL:[NSURL dft_baseURL:(NSString *)kDFTNetworkProdEnvironementURL secured:YES]];
	return self;
}

#pragma mark
#pragma mark - Headers

- (void)addSessionTokenHeader
{
	[self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", self.sessionToken]
				  forHTTPHeaderField:(NSString *)kDFTNetworkHeaderSessionTokenKey];
}

- (void)removeTokenSessionHeader
{
	[self.requestSerializer setValue:nil
				  forHTTPHeaderField:(NSString *)kDFTNetworkHeaderSessionTokenKey];
}

#pragma mark
#pragma mark - Logging

- (void)showLogsForDataTask:(NSURLSessionDataTask *)task withError:(NSError *)error
{
	NSString *curl = [[[PcURLRequestFormatter alloc] initWithOptions:PcURLRequestOptionPretty]
					  stringFromURLRequest:task.originalRequest];
	NSLog(@"Request task %@ failed with error \n%@\n\nResponseObject = %@\nCURL = \n%@", task, error.localizedDescription, error.userInfo, curl);
}

#pragma mark
#pragma mark - HTTP Methods override -

#pragma mark GET

- (NSURLSessionDataTask *)GET:(NSString *)URLString
				   parameters:(id)parameters
					  HEADERS:(NSDictionary *)headers
					 progress:(void (^)(NSProgress * _Nonnull))downloadProgress
					  success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
					  failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
	return [self GET:URLString
		  parameters:parameters
			 HEADERS:headers
	   customTimeout:0.0
			progress:downloadProgress
			 success:success
			 failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
				   parameters:(id)parameters
					  HEADERS:(NSDictionary *)headers
				customTimeout:(NSTimeInterval)timeout
					 progress:(void (^)(NSProgress * _Nonnull))downloadProgress
					  success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
					  failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
	[self addSessionTokenHeader];

	NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"GET"
														URLString:URLString
													   parameters:parameters
												   uploadProgress:nil
												 downloadProgress:downloadProgress
														  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
									  {
										  [self showLogsForDataTask:task withError:nil];

										  if (success) {
											  if (responseObject == nil || [responseObject isKindOfClass:[NSNull class]]) {
												  failure(task, [NSError new]);
											  }
											  else {
												  success(task, responseObject);
											  }

										  }
									  }
														  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
									  {
										  [self showLogsForDataTask:task withError:error];
										  if (failure)
											  failure(task, error);
									  }];

	[dataTask resume];


	return dataTask;
}

#pragma mark POST

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
	//if we are not in the route for getting a token we add the session token to the headers
	if (![URLString isEqualToString:(NSString *)kDFTNetworkRouteAuth]) {
		[self addSessionTokenHeader];
	}

	return [super POST:URLString
			parameters:parameters
			  progress:uploadProgress
			   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
				   if (success) {
					   if (responseObject == nil || [responseObject isKindOfClass:[NSNull class]]) {
						   failure(task, [NSError new]);
					   }
					   else {
						   success(task, responseObject);
					   }
				   }
			   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
				   [self showLogsForDataTask:task withError:error];

				   if (failure)
					   failure(task, error);
			   }];
}

#pragma mark PUT

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
				   parameters:(id)parameters
					  success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
					  failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
	[self addSessionTokenHeader];

	void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
	void(^failureBlock)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error);

	successBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
	{
		if (success) {
			if (responseObject == nil || [responseObject isKindOfClass:[NSNull class]]) {
				failure(task, [NSError new]);
			}
			else {
				success(task, responseObject);
			}
		}
	};
	failureBlock = ^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
	{
		[self showLogsForDataTask:task withError:error];
		if (failure)
			failure(task, error);
	};

	return ([super PUT:URLString parameters:parameters success:success failure:failure]);
}

#pragma mark DELETE

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(id)parameters
						 success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
						 failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
	[self addSessionTokenHeader];

	void(^successBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
	void(^failureBlock)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error);

	successBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
	{
		if (success) {
			if (responseObject == nil || [responseObject isKindOfClass:[NSNull class]]) {
				failure(task, [NSError new]);
			}
			else {
				success(task, responseObject);
			}
		}

	};
	failureBlock = ^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
	{
		[self showLogsForDataTask:task withError:error];

		if (failure)
			failure(task, error);
	};

	return [super DELETE:URLString parameters:parameters success:successBlock failure:failureBlock];
}

#pragma mark
#pragma mark - Custom data task

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
									   URLString:(NSString *)URLString
									  parameters:(id)parameters
								  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
								downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
										 success:(void (^)(NSURLSessionDataTask *, id))success
										 failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
	NSError *serializationError = nil;
	NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];

	if (serializationError)
	{
		if (failure)
		{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
			dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
				failure(nil, serializationError);
			});
#pragma clang diagnostic pop
		}
		return nil;
	}

	__block NSURLSessionDataTask *dataTask = nil;
	dataTask = [self dataTaskWithRequest:request
						  uploadProgress:uploadProgress
						downloadProgress:downloadProgress
					   completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error)
				{
					if ((error || responseObject == nil || [responseObject isKindOfClass:[NSNull class]]) && failure)
						failure(dataTask, error);
					else if (success)
						success(dataTask, responseObject);
				}];

	return dataTask;
}

#pragma mark
#pragma mark - Retry

- (void)retryDataTask:(NSURLSessionDataTask *)dataTask
{
	[dataTask resume];
}

#pragma mark
#pragma mark - Session API Calls

- (void)updateSessionToken:(NSString *)newToken
{
	self.sessionToken = newToken;
}

- (void)createSessionWithUserIdentifier:(NSString *)identifier
							   password:(NSString *)password
							  timestamp:(NSString *)timestamp
								 secret:(NSData *)secret
							 completion:(DFTNetworkCompletion)completion
{
	NSDictionary *parameters = nil;

	NSCharacterSet *forbiddenChars = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
	NSString *trix = [[secret.description stringByTrimmingCharactersInSet:forbiddenChars] stringByReplacingOccurrencesOfString:@" " withString:@""];
	password = [[password stringByTrimmingCharactersInSet:forbiddenChars] stringByReplacingOccurrencesOfString:@" " withString:@""];
	parameters =
	@{
	  kDFTNetworkParamKeyIdentifier : identifier,
		  kDFTNetworkParamKeyPassword : password,
		  kDFTNetworkParamKeyTimestamp : timestamp,
		  kDFTNetworkParamKeySecret : trix
	  };

	[self POST:(NSString *)kDFTNetworkRouteAuth
	parameters:parameters
	  progress:nil
	   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
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

- (void)closeSessionWithCompletion:(DFTNetworkCompletion)completion
{
	[self DELETE:(NSString *)kDFTNetworkRouteAuth
	  parameters:@{}
		 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
	 {
		 [self removeTokenSessionHeader];
		 if (completion)
			 completion(task, responseObject, nil);
	 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		 if (completion)
			 completion(task, nil, error);
	 }];
}

@end




















