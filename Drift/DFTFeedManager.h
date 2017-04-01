//
//  DFTFeedManager.h
//  Drift
//
//  Created by Thierry Ng on 22/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DFTManagerConstants.h"
#import "DFTDrop.h"

@interface DFTFeedManager : NSObject

- (void)buildFeedWithCompletion:(DFTManagerCompletion)completion;

@end
