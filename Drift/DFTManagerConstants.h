//
//  DFTManagerConstants.h
//  Drift
//
//  Created by Thierry Ng on 17/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MGENError.h"
#import "DFTNetworkClient.h"

//#import "NSObject+MGENManagerErrorHandler.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^DFTManagerCompletion)(id _Nullable responseObject,
									  NSError * _Nullable error);

//MGENError* mgenErrorFromNetworkClientError(NSError *error);
//MGENError* mgenErrorWhenUnserializedJSONObjectFromServer(NSError *error);
//MGENError* mgenErrorWhenReadingJSONFile(NSError *error);

NS_ASSUME_NONNULL_END
