//
//  DFTNetworkClient+DFTUser.h
//  Drift
//
//  Created by Thierry Ng on 03/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTNetworkClient.h"
#import "DFTUser.h"

@interface DFTNetworkClient (DFTUser)

- (void)createUser:(DFTUser *)user withCompletion:(DFTNetworkCompletion)completion;
- (void)editUser:(DFTUser *)user withCompletion:(DFTNetworkCompletion)completion;
- (void)deleteUser:(DFTUser *)user withCompletion:(DFTNetworkCompletion)completion;
- (void)retrieveAllUsersWithCompletion:(DFTNetworkCompletion)completion;

@end
