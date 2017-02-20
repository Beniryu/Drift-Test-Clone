//
//  DFTSessionManager.h
//  
//
//  Created by Thierry Ng on 17/11/2016.
//
//

#import <Foundation/Foundation.h>
#import "DFTManagerConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class DFTUser;

@interface DFTSessionManager : NSObject

@property (nonatomic, readonly) NSString   *sessionToken;
@property (nonatomic, readonly) DFTUser    *user;

+ (instancetype)currentSession;

#pragma mark -
#pragma mark Session Creation

- (void)createSessionTokenForUser:(NSString *)identifier
					  withPassword:(NSString *)password
						autoLogin:(BOOL)autoLoginActived
					   completion:(DFTManagerCompletion)completion;

//- (void)autoCreateSessionWithcompletion:(DFTManagerCompletion)completion;

//- (void)closeSessionWithCompletion:(DFTManagerCompletion)completion;

//+ (nullable NSString *)messageErrorForIdentifier:(NSString *)identifier
//								andPassword:(NSString *)password;

#pragma mark
#pragma mark - Credentials

//- (NSString *)retrieveUserIdentifier;
//- (NSString *)retrieveUserPassword;

#pragma mark -
#pragma mark Local Authent

//+ (BOOL)isAutoLoginEnabled;

@end

NS_ASSUME_NONNULL_END
