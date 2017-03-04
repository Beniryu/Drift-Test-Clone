//
//  DFTSegmentedControl.h
//  Drift
//
//  Created by Jonathan Nguyen on 02/03/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DFTSegmentedControlDelegate
@optional
- (void)segmentedControlValueChanged:(NSInteger)index;
@end

@interface DFTSegmentedControl : UIView
@property (nonatomic, weak) id <DFTSegmentedControlDelegate> delegate;

@end
