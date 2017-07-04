//
//  DFTUserManager.h
//  Drift
//
//  Created by Thierry Ng on 07/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFTManagerConstants.h"

#import "DFTUser.h"

@interface DFTUserManager : NSObject

- (void)createUser:(DFTUser *)user withCompletion:(DFTManagerCompletion)completion;
- (void)editUser:(DFTUser *)user withCompletion:(DFTManagerCompletion)completion;
- (void)deleteUser:(DFTUser *)user withCompletion:(DFTManagerCompletion)completion;
- (void)allUsersWithCompletion:(DFTManagerCompletion)completion;

@end
