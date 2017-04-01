//
//  DFTNetworkClient+DFTDrop.h
//  Drift
//
//  Created by Thierry Ng on 22/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTNetworkClient.h"

#import "DFTDrop.h"

@interface DFTNetworkClient (DFTDrop)

- (void)retrieveDropWithId:(NSNumber *)dropID withCompletion:(DFTNetworkCompletion)completion;
- (void)createDrop:(DFTDrop *)drop withCompletion:(DFTNetworkCompletion)completion;
- (void)editDrop:(DFTDrop *)drop withCompletion:(DFTNetworkCompletion)completion;
- (void)deleteDrop:(DFTDrop *)drop withCompletion:(DFTNetworkCompletion)completion;
- (void)getGlobalFeedDropsForPosition:(CLLocationCoordinate2D)position withCompletion:(DFTNetworkCompletion)completion;

@end
