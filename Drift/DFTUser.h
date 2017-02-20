//
//  DFTUser.h
//  Drift
//
//  Created by Thierry Ng on 03/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFTObject.h"

@interface DFTUser : DFTObject

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSDate *registration;
@property (nonatomic) NSDate *lastConnection;

@end
