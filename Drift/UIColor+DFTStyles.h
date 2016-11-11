//
//  UIColor+DFTStyles.h
//  Drift
//
//  Created by Thierry Ng on 10/11/16.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DFTStyles)

#pragma mark
#pragma mark - Texts

/**
 gray/blue color for some texts (#fff)

 @return Color #fff
 */
+ (instancetype)dft_slateBlueColor;

#pragma mark
#pragma mark - Backgrounds

/**
 Light red color used in button backgrounds

 @return Color #F3F3F3
 */
+ (instancetype)dft_lightRedColor;

/**
 Aquamarine (greenish light blue) color used in button backgrounds

 @return Color #3A3A3A
 */
+ (instancetype)dft_aquamarineColor;

@end

NS_ASSUME_NONNULL_END