//
//  DFTSessionManager.m
//  
//
//  Created by Thierry Ng on 17/11/2016.
//
//

#import "DFTSessionManager.h"

#import "DFTUser.h"
#import <Mantle.h>
#import <CommonCrypto/CommonHMAC.h>

@interface DFTSessionManager () <NSURLSessionDelegate>

@property (nonatomic, readwrite) NSString   *sessionToken;
@property (nonatomic, readwrite) DFTUser    *user;

@end

@implementation DFTSessionManager

const NSString *kDFTAuthenticationSignatureKey = @"dk3rE9ZRPO34azE1";

#pragma mark
#pragma mark - Singleton class

+ (instancetype)currentSession
{
	static DFTSessionManager *singleton = nil;
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^
	{
		singleton = [DFTSessionManager new];
	});
	return singleton;
}

#pragma mark
#pragma mark - Helpers

- (NSData *)hmacForAuthenticationSigningWithIdentifier:(NSString *)identifier
											andTimestamp:(NSString *)timestamp
{
	NSString *value = [NSString stringWithFormat:@"%@:%@", identifier, timestamp];


	const char *cKey  = [kDFTAuthenticationSignatureKey cStringUsingEncoding:NSUTF8StringEncoding];
	const char *cData = [value cStringUsingEncoding:NSUTF8StringEncoding];
	unsigned char cHMAC[CC_SHA512_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

	return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}
- (NSString *) createSHA512:(NSString *)source
{
	const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
	NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
	uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
	CC_SHA512(keyData.bytes, (unsigned int)keyData.length, digest);

	NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
	return [out description];
}
#pragma mark
#pragma mark - API Calls

- (void)createSessionTokenForUser:(NSString *)identifier
					  withPassword:(NSString *)password
						autoLogin:(BOOL)autoLoginActived
					   completion:(DFTManagerCompletion)completion
{
	DFTNetworkClient *networkClient = [DFTNetworkClient sharedInstance];
	NSDateFormatter *df = [NSDateFormatter new];
	NSString *timestamp = nil;

	df.dateFormat = @"yyyyMMddHHmmss";
	timestamp = [df stringFromDate:[NSDate date]];

	NSData *secretData = [self hmacForAuthenticationSigningWithIdentifier:identifier andTimestamp:timestamp];

	[networkClient createSessionWithUserIdentifier:identifier
										  password:[[self createSHA512:password] description]
										 timestamp:timestamp
											secret:secretData
										completion:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject, NSError * _Nullable error)
	 {
		 if (error || ![responseObject[@"ReturnCode"] isEqualToString:@"AUTH_OK"])
		 {
			 NSLog(@"Network login error : %@", error);
			 return ;
		 }

		 NSLog(@"response = %@", responseObject);
		 NSError *sError = nil;

		 self.sessionToken = responseObject[@"ReturnMessage"][@"JWT"];
		 [[DFTNetworkClient sharedInstance] updateSessionToken:self.sessionToken];
		 self.user = [MTLJSONAdapter modelOfClass:[DFTUser class] fromJSONDictionary:responseObject[@"ReturnMessage"][@"User"] error:&sError];
		 if (!sError)
		 {
			 if (completion)
				 completion(responseObject, error);
		 }
		 else
			 NSLog(@"User serialisation error");
	 }];
}

@end
