//
//  DFTFeedCell.h
//  Drift
//
//  Created by Thierry Ng on 26/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DFTDrop;

@interface DFTFeedCell : UICollectionViewCell

- (void)configureWithDrop:(DFTDrop *)drop;
- (void)hideProfilePic;

@end
