//
//  DFTUserManager.m
//  Drift
//
//  Created by Thierry Ng on 07/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTUserManager.h"
#import "DFTNetworkClient+DFTUser.h"


@implementation DFTUserManager

- (void)createUser:(DFTUser *)user withCompletion:(DFTManagerCompletion)completion
{
    [[DFTNetworkClient sharedInstance] createUser:user
                                   withCompletion:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject, NSError * _Nullable error)
     {
         NSLog(@"%@", responseObject);
         NSLog(@"error : %@", error);
     }];
}

- (void)editUser:(DFTUser *)user withCompletion:(DFTManagerCompletion)completion
{
    [[DFTNetworkClient sharedInstance] editUser:user
                                 withCompletion:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject, NSError * _Nullable error)
     {
         NSLog(@"%@", responseObject);
         
         if (error == nil && completion)
         {
             completion(responseObject, error);
         }
     }];
}

- (void)deleteUser:(DFTUser *)user withCompletion:(DFTManagerCompletion)completion
{
    
}

@end
