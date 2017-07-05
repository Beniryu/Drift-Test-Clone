//
//  DFTDropManager.h
//  Drift
//
//  Created by Thierry Ng on 04/07/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DFTManagerConstants.h"
#import "DFTDrop.h"

@interface DFTDropManager : NSObject

- (void)createDrop:(DFTDrop *)drop withCompletion:(DFTManagerCompletion)completion;

@end
